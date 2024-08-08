//
//  RegisterModel.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 JAME 214. All rights reserved.
//

import Foundation
struct  RegisterModel: Codable{
    var code:String?
    var message:String?
   
    init(_ JSON : [String:Any]){
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        
        
    }
}

//MARK: - Login
struct RegisterRequest:Codable{
    var first_name:String
    var last_name:String
    var email:String
    var password:String
    var confirm_password:String
    
}
