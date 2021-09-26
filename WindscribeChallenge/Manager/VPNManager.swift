//
//  VPNManager.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation
import NetworkExtension

extension NEVPNStatus {
    var message: String {
        switch self {
        case .invalid:
            return "Invalid"
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        case .reasserting:
            return "Reasserting"
        case .disconnecting:
            return "Disconnecting"
        @unknown default:
            fatalError()
        }
    }
}

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
    
    var statusDidChange: ((NEVPNStatus) -> Void)?
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(VPNManager.statusDidChange(_:)),
                                               name: Notification.Name.NEVPNStatusDidChange,
                                               object: nil)
    }
    
    @objc private func statusDidChange(_ notification: Notification?) {
        // Notify do somethings
        print(#function)
        if self.manager.connection.status == .invalid {
            print("VPN configuration is invalid")
        } else if self.manager.connection.status == .disconnected {
            print("VPN is disconnected.")
        } else if self.manager.connection.status == .connecting {
            print("VPN is connecting...")
        } else if self.manager.connection.status == .reasserting {
            print("VPN is reasserting...")
        } else if self.manager.connection.status == .disconnecting {
            print("VPN is disconnecting...")
        } else if self.manager.connection.status == .connected {
            print("VPN Connected")
        }
        self.statusDidChange?(self.manager.connection.status)
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
    
    func connectIKEv2(config: VPNConfiguration,
                      onError: @escaping (String) -> Void) {
        let protocolConfiguration = NEVPNProtocolIKEv2()
        
        protocolConfiguration.authenticationMethod = .none
        protocolConfiguration.serverAddress = config.serverAddress
        protocolConfiguration.username = config.username
        protocolConfiguration.passwordReference = config.password
        protocolConfiguration.remoteIdentifier = config.remoteIdentifier
        protocolConfiguration.useExtendedAuthentication = true
        
        protocolConfiguration.useConfigurationAttributeInternalIPSubnet = false
        protocolConfiguration.disconnectOnSleep = false
        
        protocolConfiguration.ikeSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256GCM
        protocolConfiguration.ikeSecurityAssociationParameters.diffieHellmanGroup = .group21
        protocolConfiguration.ikeSecurityAssociationParameters.integrityAlgorithm = .SHA256
        protocolConfiguration.ikeSecurityAssociationParameters.lifetimeMinutes = 1440
        
        protocolConfiguration.childSecurityAssociationParameters.encryptionAlgorithm  = .algorithmAES256GCM
        protocolConfiguration.childSecurityAssociationParameters.diffieHellmanGroup = .group21
        protocolConfiguration.childSecurityAssociationParameters.integrityAlgorithm = .SHA256
        protocolConfiguration.childSecurityAssociationParameters.lifetimeMinutes = 1440
        
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
    
    func disconnect(completionHandler: (() -> Void)? = nil) {
        manager.isOnDemandEnabled = false
        manager.saveToPreferences { _ in
            self.manager.connection.stopVPNTunnel()
            completionHandler?()
        }
    }
}
