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

import ballerina/lang.array;
import ballerina/log;
import ballerinax/financial.iso8583;

function countBitmapsFromHexString(string data) returns int|error {
    // parse the first character of the bitmap to determine whether there are more bitmaps
    int count = 1;
    int idx = 0;
    int a = check int:fromHexString(data.substring(idx, idx + 2));

    while (hasMoreBitmaps(a)) {
        count += 1;
        idx += 16;
        a = check int:fromHexString(data.substring(idx, idx + 2));
    }
    return count;
}

function hasMoreBitmaps(int data) returns boolean {
    int mask = 1 << 7;
    int bitWiseAnd = data & mask;
    if (bitWiseAnd == 0) {
        return false;
    }
    return true;
}

function hexStringToString(string hexStr) returns string|error {
    byte[] byteArray = check array:fromBase16(hexStr);
    return check string:fromBytes(byteArray);
}

function build8583Response(string msg) returns byte[]|error {

    byte[] mti = msg.substring(0, 4).toBytes();

    int bitmapCount = check countBitmapsFromHexString(msg.substring(4));
    byte[] payload = msg.substring(4 + 16 * bitmapCount).toBytes();
    byte[] bitmaps = check array:fromBase16(msg.substring(4, 4 + 16 * bitmapCount));
    // byte[] versionBytes = "ISO198730           ".toBytes();
    int payloadSize = mti.length() + bitmaps.length() + payload.length();
    string header = payloadSize.toHexString().padZero(4); //todo 8
    byte[] headerBytes = check array:fromBase16(header);

    return [...headerBytes, ...mti, ...bitmaps, ...payload];
}

function sendError(string errorCode, string mti, anydata originalMsg) returns byte[]|error {
    match mti {
        TYPE_MTI_0200 => {
            MTI_0200 originalIso8583Msg = <MTI_0200>originalMsg;
            MTI_0210 responseIso8583Msg = buildMTI0210error(originalIso8583Msg, errorCode);
            string|iso8583:ISOError encodedResponse = iso8583:encode(responseIso8583Msg);
            if (encodedResponse is iso8583:ISOError) {
                log:printError("Error occurred while encoding the error response message");
            } else {
                return check build8583Response(encodedResponse);
            }
        }
        // todo handle other MTIs
        _ => {
            log:printError("Unsupported MTI for error response");
        }
    }
    return error("Error occurred while sending the error response");
};
