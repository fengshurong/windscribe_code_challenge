//
//  ServerListViewModel.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation
import UIKit
import NetworkExtension

enum UserDefaultsKey: String {
    case dnsHostname
    case hostname
    case groupName
}

class ServerListViewModel {
    
    private let service: WindscribeApi
    private let vpnManager = VPNManager.shared
    var locations = [Location]()
    var selectedLocation: Location?
    var connectingLocation: Location?
    var connectingLocationNode: Node?
    var status: NEVPNStatus = VPNManager.shared.status
    private var isAutoConnect: Bool = false
    var defaultConfig: VPNConfiguration?
    
    init(service: WindscribeApi) {
        self.service = service
        self.fetchDefaultConfigVPN()
    }
    
    private func fetchDefaultConfigVPN() {
        let userDefault = UserDefaults.standard
        guard let dnsHostname = userDefault.string(forKey: UserDefaultsKey.dnsHostname.rawValue),
              let hostname = userDefault.string(forKey: UserDefaultsKey.hostname.rawValue),
                let serverName = userDefault.string(forKey: UserDefaultsKey.groupName.rawValue) else {
            return
        }
        self.defaultConfig = VPNConfiguration(dnsHostname,
                                              hostname,
                                              serverName)
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
            
            if status == .connected {
                self.saveConfigToDefatult()
            }
            didChange?()
        }
    }
    
    func autoConnectVPN() {
        if let connectingLocation = connectingLocation,
           let node = connectingLocationNode {
            let config = VPNConfiguration(connectingLocation.dnsHostname,
                                          node.hostname,
                                          node.group)
            self.connectVPN(config) { _ in }
        } else if let defaultConfig = defaultConfig {
            self.connectVPN(defaultConfig) { _ in }
        }
    }
    
    func connectVPN(_ config: VPNConfiguration,
                    onError: @escaping ((String) -> Void)) {
        if vpnManager.isDisconnected {
            self.vpnManager.connectIKEv2(config: config,
                                         onError: onError)
        } else {
            self.disconnectVPN {
                self.isAutoConnect = true
            }
        }
    }
    
    func disconnectVPN(_ completionHandler: (() -> Void)? = nil) {
        self.vpnManager.disconnect(completionHandler: completionHandler)
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
    
    func saveConfigToDefatult() {
        guard let connectingLocationNode = connectingLocationNode,
                let connectingLocation = connectingLocation else {
            return
        }
        let userDefault = UserDefaults.standard
        userDefault.setValue(connectingLocation.dnsHostname, forKey: UserDefaultsKey.dnsHostname.rawValue)
        userDefault.setValue(connectingLocationNode.hostname, forKey: UserDefaultsKey.hostname.rawValue)
        userDefault.setValue(connectingLocationNode.group, forKey: UserDefaultsKey.groupName.rawValue)
        userDefault.synchronize()
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
