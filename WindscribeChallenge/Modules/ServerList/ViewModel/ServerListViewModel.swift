//
//  ServerListViewModel.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation
import UIKit
import NetworkExtension

class ServerListViewModel {
    
    private let service: WindscribeApi
    var locations = [Location]()
    var selectedLocation: Location?
    var connectingLocation: Location?
    var connectingLocationNode: Node?
    var status: NEVPNStatus = VPNManager.shared.status
    
    init(service: WindscribeApi) {
        self.service = service
    }
    
    func vpnStatusDidChange(didChange: (() -> Void)?) {
        VPNManager.shared.statusDidChange = {[weak self] status in
            self?.status = status
            didChange?()
        }
    }
    
    func connectVPN(_ config: VPNConfiguration,
                    onError: @escaping ((String) -> Void)) {
        VPNManager.shared.connectIKEv2(config: config,
                                       onError: onError)
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
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return self.locations.count
    }
    
    func locationAt(indexPath: IndexPath) -> Location {
        return self.locations[indexPath.row]
    }
}
