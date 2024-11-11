// Copyright (c) 2024 WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/constraint;
import ballerina/http;
import ballerina/lang.array;
import ballerina/log;
import ballerina/uuid;
import ballerinax/financial.iso8583;
import ballerinax/financial.iso20022.payments_clearing_and_settlement as iso;

configurable BackendServiceConfig backendServiceConfig = ?;
string backendServiceUrl = backendServiceConfig.host + ":" + backendServiceConfig.port.toString();
http:Client backendClient = check new (backendServiceUrl);

# Handles inbound transactions and return response.
#
# + data - byte array of the incoming message
# + return - byte array of the response message
public function handleInbound(byte[] & readonly data) returns byte[]|error {

    string hex = array:toBase16(data);
    log:printDebug("[Transaction Handler] Received message from the network driver: " + hex);
    log:printDebug("[Transaction Handler] Recieived data string: " + data.toString());
    int headerLength = inboundConfig.message.headerLength * 2; // length provided as no. of bytes
    string versionNameString = inboundConfig.message.versionNameString ?: "";
    int versionNameLength = versionNameString.length();
    int mtiLength = inboundConfig.message.mtiLength * 2; // length provided as no. of bytes
    int nextIndex = headerLength + versionNameLength;
    // let's convert all to the original hex representation. Even though this is a string,
    // it represents the actual hexa decimal encoded byte stream.
    // extract the message type identifier 
    // int msgLength = check int:fromHexString(hex.substring(0, headerLength));
    string mtiMsg = hex.substring(nextIndex, nextIndex + mtiLength);
    nextIndex = nextIndex + mtiLength;
    // count the number of bitmaps. there can be multiple bitmaps. but the first bit of the bitmap indicates whether 
    // there is another bitmap.
    int bitmapCount = check countBitmapsFromHexString(hex.substring(nextIndex));

    // a bitmap in the hex representation is represented in 16 chars.
    int bitmapLastIndex = nextIndex + 16 * bitmapCount;
    string bitmaps = hex.substring(nextIndex, bitmapLastIndex);
    string dataString = hex.substring(bitmapLastIndex);

    string correlationId = uuid:createType4AsString();
    // parse ISO 8583 message
    string convertedMti = check hexStringToString(mtiMsg.padZero(4));
    string convertedDataString = check hexStringToString(dataString);

    log:printDebug(string `[Transaction Handler] Decoded message successfully.`, MTI = convertedMti, Bitmaps = bitmaps,
            Data = convertedDataString);
    string msgToParse = convertedMti + bitmaps + convertedDataString;
    log:printDebug(string `[Transaction Handler] Parsing the iso 8583 message.`, Message = msgToParse);

    anydata|iso8583:ISOError parsedISO8583Msg = iso8583:parse(msgToParse);

    if (parsedISO8583Msg is iso8583:ISOError) {
        log:printError("[Transaction Handler] Error occurred while parsing the ISO 8583 message", 
            err = parsedISO8583Msg);
        return error("Error occurred while parsing the ISO 8583 message: " + parsedISO8583Msg.message);
    }
    match convertedMti {
        TYPE_MTI_0100 => {
            log:printDebug("[Transaction Handler] MTI 0100 message received");
            MTI_0100 validatedMsg = check constraint:validate(parsedISO8583Msg);
            // call backend service
            http:Request request = new;
            request.setHeader(CONTENT_TYPE, CONTENT_TYPE_APPLICATION_JSON);
            request.setHeader(CORRELATION_ID, correlationId);
            request.setPayload(validatedMsg);

            http:Response httpResponse = check backendClient->/'transaction/authorization.post(request);
            string responseCode;
            if httpResponse.statusCode == 202 {
                log:printDebug("[Transaction Handler] Authorization is accepted by the backend");
                responseCode = "00";
            } else {
                log:printError("[Transaction Handler] Authorization is rejected by the backend");
                responseCode = "06";
            }

            MTI_0110 responseMsg = transformMTI0100toMTI0110(validatedMsg, responseCode);
            string|iso8583:ISOError encodedMsg = iso8583:encode(responseMsg);
            if (encodedMsg is iso8583:ISOError) {
                log:printError("[Transaction Handler] Error occurred while encoding the ISO 8583 message",
                        err = encodedMsg);
                return sendError("06", convertedMti, validatedMsg);
            }
            byte[]|error responsebytes = build8583Response(encodedMsg);

            if responsebytes is error {
                log:printError("[Transaction Handler] Error occurred while building the response message: "
                        + responsebytes.message());
                return sendError("06", convertedMti, validatedMsg);
            }
            return responsebytes;
        }
        TYPE_MTI_0200 => {
            log:printDebug("[Transaction Handler] MTI 0200 message received");
            MTI_0200 validatedMsg = check constraint:validate(parsedISO8583Msg);
            // transform to ISO 20022 message
            iso:Pacs008Document|error iso20022Msg = transformmti200toPacs008(validatedMsg);
            if iso20022Msg is error {
                log:printError("[Transaction Handler] Error occurred while transforming the ISO 8583 message to " +
                    "ISO 20022");
                return sendError("06", convertedMti, validatedMsg);
            }
            // call backend service
            http:Request request = new;
            request.setHeader(CONTENT_TYPE, CONTENT_TYPE_APPLICATION_JSON);
            request.setHeader(CORRELATION_ID, correlationId);
            request.setPayload(iso20022Msg.toJson());

            http:Response httpResponse = check backendClient->/'transaction/financial.post(request);
            string responseCode;
            if httpResponse.statusCode == 202 {
                log:printDebug("[Transaction Handler] Transaction is accepted by the backend");
                responseCode = "00";
            } else {
                log:printError("[Transaction Handler] Transaction is rejected by the backend");
                responseCode = "06";
            }

            MTI_0210 responseMsg = transformMTI0200toMTI0210(validatedMsg, responseCode);
            string|iso8583:ISOError encodedMsg = iso8583:encode(responseMsg);
            if (encodedMsg is iso8583:ISOError) {
                log:printError("[Transaction Handler] Error occurred while encoding the ISO 8583 message", 
                    err = encodedMsg);
                return sendError("06", convertedMti, validatedMsg);
            }
            byte[]|error responsebytes = build8583Response(encodedMsg);

            if responsebytes is error {
                log:printError("[Transaction Handler] Error occurred while building the response message: "
                        + responsebytes.message());
                return sendError("06", convertedMti, validatedMsg);
            }
            return responsebytes;
        }
        TYPE_MTI_0800 => {
            log:printDebug("[Transaction Handler] MTI 0800 message received");
            MTI_0800 validatedMsg = check constraint:validate(parsedISO8583Msg);
            MTI_0810 responseMsg = transformMTI0800toMTI0810(validatedMsg);
            string|iso8583:ISOError encodedMsg = iso8583:encode(responseMsg);
            if (encodedMsg is iso8583:ISOError) {
                log:printError("[Transaction Handler] Error occurred while encoding the ISO 8583 message", 
                    err = encodedMsg);
                return sendError("06", convertedMti, validatedMsg);
            }
            byte[]|error responsebytes = build8583Response(encodedMsg);

            if responsebytes is error {
                log:printError("[Transaction Handler] Error occurred while building the response message: "
                        + responsebytes.message());
                return sendError("06", convertedMti, validatedMsg);
            }
            return responsebytes;
        }
        _ => {
            log:printError("[Transaction Handler] MTI is not supported");
            return error("MTI is not supported");
        }
    }
};
