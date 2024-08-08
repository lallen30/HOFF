//
//  ButtonCell.swift
//  HOFFER
//
//  Created by JAM-E-221 on 01/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var btnOlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnOlt.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
