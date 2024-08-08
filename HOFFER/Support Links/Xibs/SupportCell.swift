//
//  SupportCell.swift
//  HOFFER
//
//  Created by JAM-E-221 on 03/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit

class SupportCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
 
    @IBOutlet weak var linkLabel: UILabel!
    
    @IBOutlet weak var tapBtnOlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerView.dropShadow(opacity: 0.5, shadowRadius: 2, cornerRadius: 12, shadowColor: .gray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
