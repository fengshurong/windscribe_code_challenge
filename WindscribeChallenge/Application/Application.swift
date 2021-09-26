//
//  Application.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation
import UIKit

final class Application {
    static let `default` = Application()
    var window: UIWindow?
    private var apiService: WindscribeApi?
    
    init() {
        self.apiService = WindscribeAPIService()
    }
    
    func presentView(with window: UIWindow?) {
        guard let window = window,
        let apiService = apiService else {
            return
        }
        self.window = window
        let viewModel = ServerListViewModel(service: apiService)
        let serverListVC = ServerListViewController.createView(with: viewModel)
        let navigationController = UINavigationController(rootViewController: serverListVC)
        self.window?.rootViewController = navigationController
    }
}
