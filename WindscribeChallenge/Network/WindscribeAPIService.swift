//
//  WindscribeAPIService.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation

final class WindscribeAPIService: WindscribeApi {
    
    var urlSession: URLSession
    
    init(_ urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchServerList(completionHandler: @escaping CompletionResult<ServerResponse>) {
        self.request(target: .serverList, completionHandler: completionHandler)
    }
}

extension WindscribeAPIService {
    func request<T: Decodable>(target: WindscribeTarget,
                               completionHandler: @escaping CompletionResult<T>) {
        self.urlSession.dataTask(with: target.urlRequest, completionHandler: { data, response, _ in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(.failedRequest))
                }
            } else {
                completionHandler(.failure(.failedRequest))
            }
        }).resume()
    }
}
