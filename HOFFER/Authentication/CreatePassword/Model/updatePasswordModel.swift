//
//  updatePasswordModel.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation

struct updatePasswordRequest: Codable{
    var email: String
    var password: String
    
}

struct  updatePasswordModel: Codable{
    
    var code:String
    var message:String
    
    
    
    
    init(_ JSON : [String:Any]){
        
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        
        
    }
}
