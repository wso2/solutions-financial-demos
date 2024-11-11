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
import ballerina/log;
import ballerinax/financial.iso20022.payments_clearing_and_settlement as iso;

service /'transaction on new http:Listener(9001) {
    resource function post financial(@http:Header string correlationId, iso:Pacs008Document payload)
        returns http:BadRequest|http:Accepted {

        log:printInfo(string `[Backend Service] Received a financial transaction request`,
                correlationId = correlationId, payload = payload);
        iso:Pacs008Document|error isopacs008 = constraint:validate(payload);
        if isopacs008 is iso:Pacs008Document {
            decimal amount = isopacs008.FIToFICstmrCdtTrf.CdtTrfTxInf[0].IntrBkSttlmAmt.
                ActiveCurrencyAndAmount_SimpleType.ActiveCurrencyAndAmount_SimpleType;
            if amount > 0d {
                return http:ACCEPTED;
            } else if isopacs008.FIToFICstmrCdtTrf.CdtTrfTxInf[0].PmtTpInf?.LclInstrm?.Prtry.toString().startsWith("31") {
                return http:ACCEPTED;
            } else {
                return http:BAD_REQUEST;
            }
        } else {
            return http:BAD_REQUEST;
        }
    }

    resource function post authorization(@http:Header string correlationId, MTI_0100 payload)
        returns http:BadRequest|http:Accepted {

        log:printInfo(string `[Backend Service] Received aa authorization request`, correlationId = correlationId);
        if payload.MTI === "0100" {
            int|error amount = int:fromString(payload.AmountTransaction);
            if amount is int && amount > 0 {
                return http:ACCEPTED;
            } else if payload.ProcessingCode.startsWith("00") {
                return http:ACCEPTED;
            } else {
                return http:BAD_REQUEST;
            }
        } else {
            return http:BAD_REQUEST;
        }
    }
}
