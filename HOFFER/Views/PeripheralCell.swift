//
//  PeripheralCell.swift
//  HOFFER
//
//  Created by macmini on 28/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class PeripheralCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    // Params
    var onConnect: (() -> Void)?
    var onDisconnect: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        connectButton.setTitle("   Connect   ", for: .normal)
        disconnectButton.setTitle("Disconnect", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    @IBAction func onClickDisconnect(_ sender: AnyObject) {
        onDisconnect?()
    }
    
    @IBAction func onClickConnect(_ sender: AnyObject) {
        onConnect?()
    }
}
