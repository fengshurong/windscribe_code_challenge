//
//  ServerListViewModel.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation
import UIKit

class ServerListViewModel {
    
    private let service: WindscribeApi
    var locations = [Location]()
    var selectedLocation: Location?
    
    init(service: WindscribeApi) {
        self.service = service
    }
    
    func retriveServerList(success: @escaping (() -> Void),
                           error: @escaping ((ErrorData?) -> Void)) {
        self.service.fetchServerList(completionHandler: { [weak self] result in
            switch result {
            case .success(let response):
                self?.locations = response.data
                success()
            case .failure(let err):
                error(err)
            }
        })
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.locations.count
    }
    
    func locationAt(indexPath: IndexPath) -> Location {
        return self.locations[indexPath.row]
    }
}
