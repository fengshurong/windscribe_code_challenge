//
//  WindscribeTarget.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation

enum WindscribeTarget {
    case serverList
    
    var urlRequest: URLRequest {
        switch self {
        case .serverList:
            guard let url = URL.init(string: self.baseURL + self.path) else {
                fatalError("URL invalid")
            }
            var request = URLRequest(url: url)
            request.httpMethod = self.httpMethod
            return URLRequest.init(url: url)
        }
    }
    
    var httpMethod: String {
        switch self {
        case .serverList:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .serverList:
            return "/serverlist/ikev2/1/89yr4y78r43gyue4gyut43guy"
        }
    }
    
    var baseURL: String {
        switch self {
        default: return "https://assets.windscribe.com"
        }
    }
}
