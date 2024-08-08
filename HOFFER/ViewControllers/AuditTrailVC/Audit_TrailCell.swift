//
//  Audit_TrailCell.swift
//  HOFFER
//
//  Created by macmini on 29/09/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class Audit_TrailCell: UITableViewCell {

    @IBOutlet weak var lblAuditNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRecord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
