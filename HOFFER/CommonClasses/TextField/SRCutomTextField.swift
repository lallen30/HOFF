//
//  SRCutomTextField.swift
//  HOFFER
//
//  Created by Admin on 31/08/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit
import TweeTextField

class SRCutomTextField: TweeAttributedTextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.activeLineColor = Global.kAppColor.PrimaryTheme
        self.activeLineWidth = 1.0
        self.infoTextColor = Global.kAppColor.ErrorColor
        self.infoFontSize = 14.0
        self.lineColor = Global.kAppColor.LightGray
        self.lineWidth = 1.0
        self.placeholderColor = Global.kAppColor.LightGray
        self.textColor = Global.kAppColor.DarkGray
        self.font = UIFont.init(name: Global.kFont.Helvetica_Regular, size: Global.kFontSize.TextFieldSize)
        self.tintColor = Global.kAppColor.PrimaryTheme
    }
}
