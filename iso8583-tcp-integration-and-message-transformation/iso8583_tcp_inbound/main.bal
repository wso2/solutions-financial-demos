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

import ballerina/io;
import ballerina/log;
import ballerina/tcp;
import ballerinax/financial.iso8583;

configurable InboundConfig inboundConfig = ?;
configurable ISOLibraryConfig isoLibraryConfig = ?;

tcp:ListenerConfiguration listenerConfig = {
    localHost: inboundConfig.host
};

# TCP service to receive inbound messages of ISO 8583.
service on new tcp:Listener(inboundConfig.port, listenerConfig) {

    // This remote method is invoked when the new client connects to the server.
    remote function onConnect(tcp:Caller caller) returns tcp:ConnectionService {
        io:println("Client connected to ISO 8583 TCP server ", inboundConfig.host, ":", inboundConfig.port, 
            "caller remote port: ", caller.remotePort);
        return new TransferService();
    }
}

service class TransferService {
    *tcp:ConnectionService;

    // This remote method is invoked once the content is received from the client.
    remote function onBytes(tcp:Caller caller, readonly & byte[] data) returns tcp:Error? {

        byte[]|error response = handleInbound(data);
        if (response is error) {
            log:printError("Error occurred while handling the inbound data", 'error = response);
            check caller->writeBytes(response.message().toBytes());
        } else {
            check caller->writeBytes(response);
        }
    }

    // This remote method is invoked in an erroneous situation,
    // which occurs during the execution of the `onConnect` or `onBytes` method.
    remote function onError(tcp:Error err) {
        log:printError("An error occurred", 'error = err);
    }

    // This remote method is invoked when the connection is closed.
    remote function onClose() {
        io:println("Client left");
    }
}

public function main() returns error? {
    // initialize ISO 8583 library with 1987 version
    check iso8583:initialize(isoLibraryConfig.fieldDefFilePath ?: "", isoLibraryConfig.fieldNamesFilePath ?: "");
}
