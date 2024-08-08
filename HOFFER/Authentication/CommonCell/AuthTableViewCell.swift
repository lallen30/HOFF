//
//  AuthTableViewCell.swift
//  HOFFER
//
//  Created by JAM-E-214 on 23/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit

class AuthTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerTextView: UIView!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    var textFieldEditingEnds : (UITextField) -> () = {_ in }
    var iconClick = true
    var istyping = true
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerTextView.dropShadow(opacity: 0.3, shadowRadius: 2, cornerRadius: 8, shadowColor: .black)
        textFieldOutlet.delegate = self
        
    }
    @IBAction func eyeBtnAction(_ sender: UIButton) {
        if(iconClick == true) {
            textFieldOutlet.isSecureTextEntry = false
            
            self.eyeBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            eyeBtn.tintColor = .black
        } else {
            textFieldOutlet.isSecureTextEntry = true
            
            self.eyeBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            eyeBtn.tintColor = .black
        }
        
        iconClick = !iconClick
    }
    
    
}

//MARK: Extensions

extension AuthTableViewCell:UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldEditingEnds(textField)
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            // Return false to disallow editing
            return istyping
        }
}
