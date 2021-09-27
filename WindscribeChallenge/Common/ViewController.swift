//
//  ViewController.swift
//  WindscribeChallenge
//
//  Created on 25/9/21.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {
    
    func showError(msgError: String) {
        let alert = UIAlertController(title: "Error", message: msgError,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
    }
    
    deinit {
        print("\(self.className) is deallocated")
    }
}
