//
//  ServerLocationTableViewCell.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import UIKit

final class ServerLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var locationNameLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var didSelectedLocationNode: ((Location, Node) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureView()
    }
    
    private func configureView() {
        tableView.register(UINib(nibName: "ServerLocationNodeTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ServerLocationNodeTableViewCell")
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = CGFloat(50)
        tableView.delegate = self
        tableView.dataSource = self
        
        expandButton.setTitle("", for: .normal)
        expandButton.backgroundColor = .clear
        expandButton.setImage(UIImage(named: "close_ic"), for: .selected)
        expandButton.setImage(UIImage(named: "expand_ic"), for: .normal)
        expandButton.isUserInteractionEnabled = false
    }
    
    private var location: Location!
    
    func configureData(_ location: Location,
                       _ selectedLocation: Location?) {
        self.locationNameLbl.text = location.name
        self.location = location
        if let selectedLocation = selectedLocation, selectedLocation.id == location.id {
            self.tableViewHeightConstraint.constant = CGFloat(self.location.nodes.count * 50)
            self.expandButton.isSelected = true
        } else {
            self.tableViewHeightConstraint.constant = 0
            self.expandButton.isSelected = false
        }
        self.tableView.reloadData()
    }
}

extension ServerLocationTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard location != nil else {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.location.nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServerLocationNodeTableViewCell", for: indexPath) as? ServerLocationNodeTableViewCell else {
            return .init()
        }
        cell.selectionStyle = .none
        let node = self.location.nodes[indexPath.row]
        cell.configurate(node)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = self.location.nodes[indexPath.row]
        self.didSelectedLocationNode?(self.location, node)
    }
}
