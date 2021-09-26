//
//  WindscribeApi.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation

typealias CompletionResult<T> = (Result<T, ErrorData>) -> Void

protocol WindscribeApi {
    func fetchServerList(completionHandler: @escaping CompletionResult<ServerResponse>)
}
