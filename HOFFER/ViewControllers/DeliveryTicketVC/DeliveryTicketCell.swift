//
//  DeliveryTicketCell.swift
//  HOFFER
//
//  Created by SiliconMac on 25/07/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class DeliveryTicketCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblParameter: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

