//
//  VPNManager.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation
import NetworkExtension

final class VPNManager: NSObject {
    
    static let shared: VPNManager = {
        let instance = VPNManager()
        instance.manager.localizedDescription = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        instance.loadProfile(completion: nil)
        return instance
    }()
    
    let manager: NEVPNManager = NEVPNManager.shared()
    public var isDisconnected: Bool {
        return (status == .disconnected) || (status == .reasserting) || (status == .invalid)
    }
    public var status: NEVPNStatus {
        return self.manager.connection.status
    }
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(VPNManager.statusDidChange(_:)),
                                               name: Notification.Name.NEVPNStatusDidChange,
                                               object: nil)
    }
    
    @objc private func statusDidChange(_: Notification?) {
        // Notify do somethings
    }
    
    private func loadProfile(completion: ((Bool) -> Void)?) {
        manager.protocolConfiguration = nil
        manager.loadFromPreferences { error in
            if let error = error {
                print("Failed to load preferences: \(error.localizedDescription)")
                completion?(false)
            } else {
                completion?(self.manager.protocolConfiguration != nil)
            }
        }
    }
        
    private func saveProfile(completion: ((Bool) -> Void)?) {
        manager.saveToPreferences { error in
            if let error = error {
                print("Failed to save profile: \(error.localizedDescription)")
                completion?(false)
            } else {
                completion?(true)
            }
        }
    }
    
    func connectIKEv2(config: ConfigurationProtocol,
                      onError: @escaping (String) -> Void) {
        let protocolConfiguration = NEVPNProtocolIKEv2()
        
        protocolConfiguration.serverAddress = config.serverAddress
        protocolConfiguration.username = config.username
        protocolConfiguration.passwordReference = config.password.utf8Encoded
        protocolConfiguration.remoteIdentifier = config.remoteIdentifier
        protocolConfiguration.useExtendedAuthentication = true
        
        self.loadProfile(completion: { _ in
            self.manager.protocolConfiguration = protocolConfiguration
            self.manager.isEnabled = true
            
            self.saveProfile(completion: { isSuccess in
                guard isSuccess else {
                    onError("Unable to save vpn profile")
                    return
                }
                self.loadProfile(completion: { isSuccess in
                    guard isSuccess else {
                        onError("Unable to load profile")
                        return
                    }
                    let isConnected = self.startVPNTunnel()
                    guard isConnected else {
                        onError("Can't connect")
                        return
                    }
                })
            })
        })
    }
    
    private func startVPNTunnel() -> Bool {
        do {
            try self.manager.connection.startVPNTunnel()
            return true
        } catch NEVPNError.configurationInvalid {
            print("Failed to start tunnel (configuration invalid)")
        } catch NEVPNError.configurationDisabled {
            print("Failed to start tunnel (configuration disabled)")
        } catch {
            print("Failed to start tunnel (other error)")
        }
        return false
    }
    
}

protocol ConfigurationProtocol {
    var serverAddress: String { get }
    var username: String { get }
    var password: String { get }
    var remoteIdentifier: String { get }
}
