//
//  SettingModel.swift
//  HOFFER
//
//  Created by JAM-E-221 on 01/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation

struct  SettingModel: Codable{
    var code:String
    var message:String
    
    init(_ JSON : [String:Any]){
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        
        
    }
}


struct  DeleteModel: Codable{
    var code:String
    var message:String
    
    init(_ JSON : [String:Any]){
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        
        
    }
}


struct  UserProfileModel: Codable{
    var code:String?
    var message:String?
    var data :  UserProFileData?
    
    init(_ JSON : [String:Any]){
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        data = UserProFileData((JSON["data"] != nil && JSON["data"] is [String : Any] && (JSON["data"] as! [String : Any]).count > 0 ? JSON["data"] as! [String : Any] : [String : Any]()))
        
        
    }
}





struct UserProFileData:Codable {
    var id:Int
    var username:String
    var password:String
    var first_name:String
    var last_name:String
    var avatar:String
    var email :String
    var trailer_no:String
    var status:Int
    var on_date:String?
    var last_login_date:String?
    var role:Int
    var device_token:String
    
    
    init(_ JSON : [String:Any]){
        id   = checkForNilAndNull(dictionary: JSON, key: "id") ? Int("\(JSON["id"]!)") ?? 0 : 0
        username   = checkForNilAndNull(dictionary: JSON, key: "username") ? "\(JSON["username"]!)" : ""
        password   = checkForNilAndNull(dictionary: JSON, key: "password") ? "\(JSON["password"]!)" : ""
        first_name   = checkForNilAndNull(dictionary: JSON, key: "first_name") ? "\(JSON["first_name"]!)" : ""
        last_name   = checkForNilAndNull(dictionary: JSON, key: "last_name") ? "\(JSON["last_name"]!)" : ""
        avatar   = checkForNilAndNull(dictionary: JSON, key: "avatar") ? "\(JSON["avatar"]!)" : ""
        email   = checkForNilAndNull(dictionary: JSON, key: "email") ? "\(JSON["email"]!)" : ""
             trailer_no   = checkForNilAndNull(dictionary: JSON, key: "trailer_no") ? "\(JSON["trailer_no"]!)" : ""
        status   = checkForNilAndNull(dictionary: JSON, key: "status") ? Int("\(JSON["status"]!)") ?? 0 : 0
        role   = checkForNilAndNull(dictionary: JSON, key: "role") ? Int("\(JSON["role"]!)") ?? 0 : 0
        on_date   = checkForNilAndNull(dictionary: JSON, key: "on_date") ? "\(JSON["on_date"]!)" : ""
        last_login_date   = checkForNilAndNull(dictionary: JSON, key: "last_login_date") ? "\(JSON["last_login_date"]!)" : ""
        device_token   = checkForNilAndNull(dictionary: JSON, key: "device_token") ? "\(JSON["device_token"]!)" : ""
    
    }
}
