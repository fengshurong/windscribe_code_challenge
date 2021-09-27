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
    private let vpnManager = VPNManager.shared
    var locations = [Location]()
    var selectedLocation: Location?
    var connectingLocation: Location?
    var connectingLocationNode: Node?
    var status: NEVPNStatus = VPNManager.shared.status
    private var isAutoConnect: Bool = false
    
    init(service: WindscribeApi) {
        self.service = service
    }
    
    func vpnStatusDidChange(didChange: (() -> Void)?) {
        VPNManager.shared.statusDidChange = {[weak self] status in
            guard let self = self else { return }
            self.status = status
            if status == .disconnected,
               self.isAutoConnect {
                self.isAutoConnect = false
                self.autoConnectVPN()
            }
            didChange?()
        }
    }
    
    func autoConnectVPN() {
        guard let connectingLocation = connectingLocation,
            let node = connectingLocationNode else {
            return
        }
        let config = VPNConfiguration(connectingLocation, node)
        self.connectVPN(config) { _ in }
    }
    
    func connectVPN(_ config: VPNConfiguration,
                    onError: @escaping ((String) -> Void)) {
        if vpnManager.isDisconnected {
            self.vpnManager.connectIKEv2(config: config,
                                           onError: onError)
        } else {
            self.vpnManager.disconnect(completionHandler: {
                self.isAutoConnect = true
            })
        }
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
}

extension ServerListViewModel {
    // UITableViewDelegate && UITableViewDataSource
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
