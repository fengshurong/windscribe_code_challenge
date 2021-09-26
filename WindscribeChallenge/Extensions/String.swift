//
//  String.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation

extension String {
    var utf8Encoded: Data? {
        get {
            return data(using: .utf8)
        }
    }
}
