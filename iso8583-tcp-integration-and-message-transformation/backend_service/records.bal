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

public type MTI_0200 record {|
    string MTI = "0200";
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for PrimaryAccountNumber"
        }
    }
    string PrimaryAccountNumber?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for ProcessingCode"
        }
    }
    string ProcessingCode;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for AmountTransaction"
        }
    }
    string AmountTransaction?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for TransmissionDateTime"
        }
    }
    string TransmissionDateTime;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for SystemTraceAuditNumber"
        }
    }
    string SystemTraceAuditNumber;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for LocalTransactionTime"
        }
    }
    string LocalTransactionTime;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for LocalTransactionDate"
        }
    }
    string LocalTransactionDate;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for MerchantType"
        }
    }
    string MerchantType;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for PointOfServiceEntryMode"
        }
    }
    string PointOfServiceEntryMode?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for PointOfServiceConditionCode"
        }
    }
    string PointOfServiceConditionCode;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for AmountTransactionFee"
        }
    }
    string AmountTransactionFee?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for AcquiringInstitutionIdentificationCode"
        }
    }
    string AcquiringInstitutionIdentificationCode;
    @constraint:String {
         pattern: {
            value: re `^[a-zA-Z0-9]+$`,
            message: "Only alpha numeric values allowed for RetrievalReferenceNumber"
        }
    }
    string RetrievalReferenceNumber;
    string CardAcceptorTerminalID?;
    string CardAcceptorIDCode?;
    string CardAcceptorNameLocation?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for CurrencyCodeTransaction"
        }
    }
    string CurrencyCodeTransaction;
    @constraint:String {
        pattern: {
            value: re `[0-1]+`,
            message: "Only binary data allowed for IntegratedCircuitCardSystemRelatedData"
        }
    }
    string IntegratedCircuitCardSystemRelatedData?;
    string AccountIdentification1?;
    string AccountIdentification2?;
    string EftTlvData?; //todo - remove optional
    @constraint:String {
        pattern: {
            value: re `[0-1]+`,
            message: "Only binary data allowed for CardIssuerReferenceData"
        }
    }
    string MessageAuthenticationCode?;
    @constraint:String {
        pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for SettlementDate"
        }
    }
    string SettlementDate?;
    @constraint:String {
        pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for DateCapture"
        }
    }
    string DateCapture?;
    @constraint:String {
        pattern: {
            value: re `[0-1]+`,
            message: "Only binary data allowed for PinData"
        }
    }
    string PinData?;
    string Track2Data?;
    string ApplicationPANSequenceNumber?;
    string CurrencyCodeCardholderBilling?;
    string PersonalIdentificationNumberData?;
    string ExpirationDate?;
    string PointOfServiceCaptureCode?;
    string CardSequenceNumber?;
    string ForwardingInstitutionIdentificationCode?;
|};

public type MTI_0100 record {|
    string MTI = "0100";
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for PrimaryAccountNumber"
        }
    }
    string PrimaryAccountNumber?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for ProcessingCode"
        }
    }
    string ProcessingCode;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for AmountTransaction"
        }
    }
    string AmountTransaction;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for TransmissionDateTime"
        }
    }
    string TransmissionDateTime;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for SystemTraceAuditNumber"
        }
    }
    string SystemTraceAuditNumber;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for LocalTransactionTime"
        }
    }
    string LocalTransactionTime;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for LocalTransactionDate"
        }
    }
    string LocalTransactionDate;
    string ExpirationDate?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for MerchantType"
        }
    }
    string MerchantType;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for PointOfServiceEntryMode"
        }
    }
    string PointOfServiceEntryMode?;
    string ApplicationPANSequenceNumber?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for PointOfServiceConditionCode"
        }
    }
    string PointOfServiceConditionCode;
    string PointOfServiceCaptureCode;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for AmountTransactionFee"
        }
    }
    string AmountTransactionFee?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for AcquiringInstitutionIdentificationCode"
        }
    }
    string AcquiringInstitutionIdentificationCode;
    string CardAcceptorTerminalID?;
    string CardAcceptorIDCode?;
    string CardAcceptorNameLocation?;
    @constraint:String {
         pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for CurrencyCodeTransaction"
        }
    }
    string CurrencyCodeTransaction;
    @constraint:String {
        pattern: {
            value: re `[0-1]+`,
            message: "Only binary data allowed for IntegratedCircuitCardSystemRelatedData"
        }
    }
    string IntegratedCircuitCardSystemRelatedData?;
    string AccountIdentification1?;
    string AccountIdentification2?;
    @constraint:String {
        pattern: {
            value: re `[0-1]+`,
            message: "Only binary data allowed for CardIssuerReferenceData"
        }
    }
    string MessageAuthenticationCode?;
    @constraint:String {
        pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for SettlementDate"
        }
    }
    string SettlementDate?;
    @constraint:String {
        pattern: {
            value: re `^\d+`,
            message: "Only numeric values allowed for DateCapture"
        }
    }
    string DateCapture?;
    @constraint:String {
        pattern: {
            value: re `[0-1]+`,
            message: "Only binary data allowed for PinData"
        }
    }
    string PinData?;
    string Track2Data?;
    string RetrievalReferenceNumber;
    string CurrencyCodeCardholderBilling?;
    string PersonalIdentificationNumberData?;
    string CardSequenceNumber?;
    string ForwardingInstitutionIdentificationCode?;
|};
