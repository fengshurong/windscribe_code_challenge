//
//  VPNConfiguration.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation

class VPNConfiguration {
    
    var username: String
    var password: Data? {
        KeychainWrapper.standard.set("xpcnwg6abh", forKey: "pass_word")
        return KeychainWrapper.standard.dataRef(forKey: "pass_word")
    }
    var remoteIdentifier: String
    var serverAddress: String
    
    init(_ location: Location,
         _ node: Node) {
        self.username = "prd_test_j4d3vk6"
        self.remoteIdentifier = location.dnsHostname ?? ""
        self.serverAddress = node.hostname ?? ""
    }
}
