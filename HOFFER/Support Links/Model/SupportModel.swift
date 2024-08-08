//
//  SupportModel.swift
//  HOFFER
//
//  Created by JAM-E-221 on 03/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation
import Foundation

struct  SupportModel: Codable{
    var code:String
    var message:String
    
    init(_ JSON : [String:Any]){
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        
    }
}
