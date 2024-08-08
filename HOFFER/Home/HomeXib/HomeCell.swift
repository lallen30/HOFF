//
//  HomeCell.swift
//  HOFFER
//
//  Created by JAM-E-214 on 29/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var outerTextView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        outerTextView.dropShadow(opacity: 0.3, shadowRadius: 2, cornerRadius: 10, shadowColor: .black)
    }

    
    
}
