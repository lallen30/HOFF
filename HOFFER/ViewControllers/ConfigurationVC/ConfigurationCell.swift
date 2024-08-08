//
//  ConfigurationCell.swift
//  HOFFER
//
//  Created by SiliconMac on 06/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class ConfigurationCell: UITableViewCell {

    @IBOutlet weak var lblParameter: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
