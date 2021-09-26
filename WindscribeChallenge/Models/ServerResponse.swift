//
//  ServerResponse.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation

struct ServerResponse: Decodable {
    let data: [Location]
}

enum ErrorData: Error {
    case message(String)
    case failedRequest
    case invalidResponse
}
