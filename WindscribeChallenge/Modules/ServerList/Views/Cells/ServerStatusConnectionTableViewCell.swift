//
//  ServerStatusConnectionTableViewCell.swift
//  WindscribeChallenge
//
//  Created on 26/09/2021.
//

import UIKit

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
    
    
    
}
