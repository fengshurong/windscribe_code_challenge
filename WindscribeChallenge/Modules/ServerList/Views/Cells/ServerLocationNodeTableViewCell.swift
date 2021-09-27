//
//  ServerLocationNodeTableViewCell.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import UIKit

final class ServerLocationNodeTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurate(_ node: Node) {
        let ip: String = node.ip ?? ""
        let group: String = node.group ?? ""
        self.groupNameLbl.text = "- " + group + " - " + ip
    }
    
}
