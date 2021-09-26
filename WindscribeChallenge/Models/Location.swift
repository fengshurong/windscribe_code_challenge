//
//  Location.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation

struct Location: Decodable {
    let id: Int
    let name: String?
    let countryCode: String?
    let dnsHostname: String?
    let nodes: [Node]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case countryCode = "country_code"
        case nodes
        case dnsHostname = "dns_hostname"
    }
}
