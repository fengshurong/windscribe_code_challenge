//
//  ServerStatusConnectionTableViewCell.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import UIKit
import NetworkExtension

class ServerStatusConnectionTableViewCell: UITableViewCell {

    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var grouplbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ node: Node?,
                   _ status: NEVPNStatus) {
        statusValueLbl.text = status.message
        if let node = node {
            grouplbl.isHidden = false
            grouplbl.text = node.group
            if status == .connected {
                statusSwitch.isOn = true
            } else if status == .disconnected || status == .disconnecting || status == .invalid {
                statusSwitch.isOn = false
            }
        } else {
            grouplbl.isHidden = true
        }
    }
}
