import ballerina/lang.'decimal as decimal0;
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

import ballerinax/financial.iso20022.payments_clearing_and_settlement as iso;

function transformMTI0800toMTI0810(MTI_0800 mti0800) returns MTI_0810 => {
    MTI: "810",
    TransmissionDateTime: mti0800.TransmissionDateTime,
    SystemTraceAuditNumber: mti0800.SystemTraceAuditNumber,
    NetworkManagementInformationCode: mti0800.NetworkManagementInformationCode,
    LocalTransactionDate: mti0800.LocalTransactionDate,
    LocalTransactionTime: mti0800.LocalTransactionTime,
    ProcessingCode: mti0800.ProcessingCode,
    CardAcceptorTerminalID: mti0800.CardAcceptorTerminalID,
    ResponseCode: "00"
};

function transformMTI0200toMTI0210(MTI_0200 mti0200, string responseCode) returns MTI_0210 => {
    MTI: "210",
    TransmissionDateTime: mti0200.TransmissionDateTime,
    SystemTraceAuditNumber: mti0200.SystemTraceAuditNumber,
    LocalTransactionDate: mti0200.LocalTransactionDate,
    LocalTransactionTime: mti0200.LocalTransactionTime,
    ProcessingCode: mti0200.ProcessingCode,
    CardAcceptorTerminalID: mti0200.CardAcceptorTerminalID,
    ResponseCode: responseCode,
    PrimaryAccountNumber: mti0200.PrimaryAccountNumber,
    AmountTransaction: mti0200.AmountTransaction ?: "0",
    MerchantType: mti0200.MerchantType,
    PointOfServiceEntryMode: mti0200.PointOfServiceEntryMode,
    PointOfServiceConditionCode: mti0200.PointOfServiceConditionCode,
    AmountTransactionFee: mti0200.AmountTransactionFee,
    AcquiringInstitutionIdentificationCode: mti0200.AcquiringInstitutionIdentificationCode,
    RetrievalReferenceNumber: mti0200.RetrievalReferenceNumber,
    CardAcceptorIDCode: mti0200.CardAcceptorIDCode,
    CardAcceptorNameLocation: mti0200.CardAcceptorNameLocation,
    CurrencyCodeTransaction: mti0200.CurrencyCodeTransaction,
    IntegratedCircuitCardSystemRelatedData: mti0200.IntegratedCircuitCardSystemRelatedData,
    AccountIdentification1: mti0200.AccountIdentification1,
    AccountIdentification2: mti0200.AccountIdentification2,
    MessageAuthenticationCode: mti0200.MessageAuthenticationCode
};

function transformMTI0100toMTI0110(MTI_0100 mti0100, string responseCode) returns MTI_0110 => {
    MTI: "110",
    TransmissionDateTime: mti0100.TransmissionDateTime,
    SystemTraceAuditNumber: mti0100.SystemTraceAuditNumber,
    LocalTransactionDate: mti0100.LocalTransactionDate,
    LocalTransactionTime: mti0100.LocalTransactionTime,
    ProcessingCode: mti0100.ProcessingCode,
    CardAcceptorTerminalID: mti0100.CardAcceptorTerminalID,
    ResponseCode: responseCode,
    PrimaryAccountNumber: mti0100.PrimaryAccountNumber,
    AmountTransaction: mti0100.AmountTransaction,
    MerchantType: mti0100.MerchantType,
    PointOfServiceEntryMode: mti0100.PointOfServiceEntryMode,
    PointOfServiceConditionCode: mti0100.PointOfServiceConditionCode,
    AmountTransactionFee: mti0100.AmountTransactionFee,
    AcquiringInstitutionIdentificationCode: mti0100.AcquiringInstitutionIdentificationCode,
    RetrievalReferenceNumber: mti0100.RetrievalReferenceNumber,
    CardAcceptorIDCode: mti0100.CardAcceptorIDCode,
    CardAcceptorNameLocation: mti0100.CardAcceptorNameLocation,
    CurrencyCodeTransaction: mti0100.CurrencyCodeTransaction,
    IntegratedCircuitCardSystemRelatedData: mti0100.IntegratedCircuitCardSystemRelatedData,
    AccountIdentification1: mti0100.AccountIdentification1,
    AccountIdentification2: mti0100.AccountIdentification2,
    MessageAuthenticationCode: mti0100.MessageAuthenticationCode,
    PointOfServiceCaptureCode: mti0100.PointOfServiceCaptureCode,
    AdditionalAmounts: mti0100.ProcessingCode.startsWith("31") ? "1500" : ""
};

function buildMTI0210error(MTI_0200 mti0200, string responseCode) returns MTI_0210 => {
    PrimaryAccountNumber: mti0200.PrimaryAccountNumber,
    ProcessingCode: mti0200.ProcessingCode,
    AmountTransaction: mti0200.AmountTransaction ?: "0",
    TransmissionDateTime: mti0200.TransmissionDateTime,
    SystemTraceAuditNumber: mti0200.SystemTraceAuditNumber,
    LocalTransactionTime: mti0200.LocalTransactionTime,
    LocalTransactionDate: mti0200.LocalTransactionDate,
    MerchantType: mti0200.MerchantType,
    PointOfServiceEntryMode: mti0200.PointOfServiceEntryMode,
    PointOfServiceConditionCode: mti0200.PointOfServiceConditionCode,
    AmountTransactionFee: mti0200.AmountTransactionFee,
    AcquiringInstitutionIdentificationCode: mti0200.AcquiringInstitutionIdentificationCode,
    RetrievalReferenceNumber: mti0200.RetrievalReferenceNumber,
    CardAcceptorTerminalID: mti0200.CardAcceptorTerminalID,
    CardAcceptorIDCode: mti0200.CardAcceptorIDCode,
    CardAcceptorNameLocation: mti0200.CardAcceptorNameLocation,
    CurrencyCodeTransaction: mti0200.CurrencyCodeTransaction,
    IntegratedCircuitCardSystemRelatedData: mti0200.IntegratedCircuitCardSystemRelatedData,
    AccountIdentification1: mti0200.AccountIdentification1,
    AccountIdentification2: mti0200.AccountIdentification2,
    MessageAuthenticationCode: mti0200.MessageAuthenticationCode,
    ResponseCode: responseCode
};

function transformmti200toPacs008(MTI_0200 mti0200) returns iso:Pacs008Document|error => {
    FIToFICstmrCdtTrf: {
        GrpHdr: {
            MsgId: mti0200.RetrievalReferenceNumber,
            CreDtTm: mti0200.TransmissionDateTime,
            NbOfTxs: "1",
            SttlmInf: {SttlmMtd: "CLRG"}
        },
        CdtTrfTxInf: [
            {
                ChrgBr: "CRED",
                Dbtr: {},
                DbtrAgt: {
                    FinInstnId: {
                        BICFI: mti0200.PointOfServiceCaptureCode
                    }
                },
                DbtrAcct: {
                    Id: {
                        Othr: {
                            Id: mti0200.PrimaryAccountNumber
                        }
                    }
                },
                PmtTpInf: {
                    LclInstrm: {
                        Prtry: mti0200.ProcessingCode
                    },
                    CtgyPurp: {
                        Prtry: mti0200.MerchantType
                    }
                },
                InstdAmt: {
                    ActiveOrHistoricCurrencyAndAmount_SimpleType: {
                        Ccy: mti0200.CurrencyCodeTransaction,
                        ActiveOrHistoricCurrencyAndAmount_SimpleType: check decimal0:fromString(mti0200.AmountTransaction ?: "0")
                    }
                },
                IntrBkSttlmAmt: {ActiveCurrencyAndAmount_SimpleType: {
                    ActiveCurrencyAndAmount_SimpleType: check decimal0:fromString(mti0200.AmountTransaction ?: "0"), 
                    Ccy: mti0200.CurrencyCodeTransaction}
                },
                PmtId: {
                    EndToEndId: mti0200.TransmissionDateTime,
                    InstrId: mti0200.LocalTransactionTime
                },
                RmtInf: {
                    Strd: [
                        {}
                    ],
                    Ustrd: [
                        mti0200.CardAcceptorNameLocation ?: ""
                    ]
                },
                CdtrAgt: {
                    FinInstnId: {
                        BICFI: mti0200.AcquiringInstitutionIdentificationCode
                    }
                },
                Cdtr: {
                    Id: {
                        OrgId: {
                            Othr: [
                                {
                                    Id: mti0200.CardAcceptorIDCode
                                }
                            ]
                        }
                    }
                }
            }
        ]
    }
};
