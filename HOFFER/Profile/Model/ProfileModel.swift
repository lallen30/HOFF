//
//  ProfileModel.swift
//  HOFFER
//
//  Created by JAM-E-221 on 02/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation

import Foundation
struct  ProfileModel: Codable{
    var code:String
    var message:String
    
    init(_ JSON : [String:Any]){
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        
        
    }
}


//MARK: - Login
struct ProfileUpdateRequest:Codable{
   
    var first_name:String
    var last_name:String
    
}
