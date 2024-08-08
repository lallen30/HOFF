//
//  ForgotModel.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//


struct ForgotRequest: Codable{
    var email: String
}

struct  ForgotModel: Codable{
    var otp:String?
    var code:String?
    var message:String?
    
    init(_ JSON : [String:Any]){
        otp   = checkForNilAndNull(dictionary: JSON, key: "otp") ? "\(JSON["otp"]!)" : ""
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        
        
    }
}

struct  ForgotErrorModel: Codable{
    var code:Int?
    var message:String?
    
    init(_ JSON : [String:Any]){
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? Int("\(JSON["code"]!)") ?? 0 : 0
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        
        
    }
}
