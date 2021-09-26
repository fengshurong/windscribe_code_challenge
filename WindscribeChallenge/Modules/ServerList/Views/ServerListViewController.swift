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
    
    var viewModel: ServerListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViuew()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.retriveServerList(success: {[weak self] in
            self?.updateView()
        }, error: { error in
            print(error.localizedDescription)
        })
    }
    
    private func configureViuew() {
        title = "Server List"
        tableView.register(UINib(nibName: "ServerStatusConnectionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ServerStatusConnectionTableViewCell")
        tableView.register(UINib(nibName: "ServerLocationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ServerLocationTableViewCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
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
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServerStatusConnectionTableViewCell", for: indexPath) as? ServerStatusConnectionTableViewCell else {
                return .init()
            }
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServerLocationTableViewCell", for: indexPath) as? ServerLocationTableViewCell else {
            return .init()
        }
        cell.selectionStyle = .none
        cell.configureData(viewModel.locationAt(indexPath: indexPath),
                           viewModel.selectedLocation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let selectedLocation = viewModel.selectedLocation,
                selectedLocation.id == viewModel.locationAt(indexPath: indexPath).id {
                self.viewModel.selectedLocation = nil
            } else {
                self.viewModel.selectedLocation = viewModel.locationAt(indexPath: indexPath)
            }
            self.updateRowAt(indexPath: indexPath)
        }
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
