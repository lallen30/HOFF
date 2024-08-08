//
//  SavedTicketListCell.swift
//  HOFFER
//
//  Created by Admin on 31/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class SavedTicketListCell: UITableViewCell {
    
    @IBOutlet weak var lblTicketTitle: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var viewRedDot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewRedDot.layer.cornerRadius = viewRedDot.frame.height/2
        viewRedDot.layer.masksToBounds = true
        viewRedDot.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.3960784314, blue: 0.4274509804, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
