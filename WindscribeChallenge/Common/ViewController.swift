//
//  ViewController.swift
//  WindscribeChallenge
//
//  Created on 25/9/21.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func test(_ sender: Any) {
        if VPNManager.shared.isDisconnected {
            let config = Test.init()
            VPNManager.shared.connectIKEv2(config: config) { msgError in
                print("msg: \(msgError)")
            }
        }
    }
}

class Test: ConfigurationProtocol {
    init() {
        
    }
    
    var serverAddress: String {
        return "us-central-020.whiskergalaxy.com"
    }
    
    var username: String {
        return "prd_test_j4d3vk6"
    }
    
    var password: String {
        return "xpcnwg6abh"
    }
    
    var remoteIdentifier: String {
        return "us-central.windscribe.com"
    }
}
