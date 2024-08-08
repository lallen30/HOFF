//
//  TripReportCell.swift
//  HOFFER
//
//  Created by Admin on 14/09/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class TripReportCell: UITableViewCell {
    
    @IBOutlet weak var lblTrailorNo: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDeliveryNo: UILabel!
    @IBOutlet weak var lblAccumulatedTotal: UILabel!
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var lblRecordNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
