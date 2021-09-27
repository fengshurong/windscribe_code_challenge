//
//  ServerListViewController.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import Foundation
import UIKit

class ServerListViewController: ViewController {
    
    class func createView(with viewmodel: ServerListViewModel) -> ServerListViewController {
        let storyboard = UIStoryboard(name: "ServerList", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ServerListViewController") as? ServerListViewController else {
            fatalError("Create ViewController Fail")
        }
        vc.viewModel = viewmodel
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var grouplbl: UILabel!
    @IBOutlet weak var groupView: UIView!
    
    var viewModel: ServerListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.retriveServerList(success: {[weak self] in
            self?.updateView()
        }, error: { error in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        
        viewModel.vpnStatusDidChange(didChange: {[weak self] in
            self?.updateStatusView()
        })
    }
    
    private func configureView() {
        title = "Server List"
        tableView.register(UINib(nibName: "ServerLocationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ServerLocationTableViewCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.configureStatusView()
    }
    
    private func configureStatusView() {
        statusSwitch.isOn = false
        statusValueLbl.text = viewModel.status.message
        groupView.isHidden = true
    }
    
    private func updateStatusView() {
        let status = viewModel.status
        statusValueLbl.text = status.message
        if status == .connected {
            statusSwitch.isOn = true
        } else if status == .disconnected ||
                    status == .disconnecting ||
                    status == .invalid {
            statusSwitch.isOn = false
        }
        
        if let node = viewModel.connectingLocationNode {
            groupView.isHidden = false
            grouplbl.text = node.group
        } else if let defaultConfig = viewModel.defaultConfig {
            groupView.isHidden = false
            grouplbl.text = defaultConfig.serverName
        } else {
            groupView.isHidden = true
        }
    }
    
    private func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func connectVPN(config: VPNConfiguration) {
        self.viewModel.connectVPN(config, onError: { msg in
            print("msg: \(msg)")
        })
    }
    
    @IBAction func statusSwitchValueChanged(_ sender: UISwitch) {
        guard viewModel.defaultConfig != nil else {
            sender.isOn = false
            return
        }
        if !sender.isOn {
            self.viewModel.disconnectVPN()
        } else {
            self.viewModel.autoConnectVPN()
        }
    }
}

extension ServerListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServerLocationTableViewCell",
                                                       for: indexPath) as? ServerLocationTableViewCell else {
            return .init()
        }
        cell.selectionStyle = .none
        cell.configureData(viewModel.locationAt(indexPath: indexPath),
                           viewModel.selectedLocation)
        cell.didSelectedLocationNode = { [unowned self] location, node in
            guard viewModel.connectingLocationNode == nil || viewModel.connectingLocationNode!.ip != node.ip else {
                return
            }
            self.viewModel.connectingLocation = location
            self.viewModel.connectingLocationNode = node
            let config = VPNConfiguration(location.dnsHostname,
                                          node.hostname,
                                          node.group)
            self.connectVPN(config: config)
            self.updateStatusView()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedLocation = viewModel.selectedLocation,
            selectedLocation.id == viewModel.locationAt(indexPath: indexPath).id {
            self.viewModel.selectedLocation = nil
        } else {
            self.viewModel.selectedLocation = viewModel.locationAt(indexPath: indexPath)
        }
        self.updateRowAt(indexPath: indexPath)
    }
    
    private func updateRowAt(indexPath: IndexPath) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  250
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
