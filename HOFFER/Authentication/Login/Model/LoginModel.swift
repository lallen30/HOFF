//
//  LoginModel.swift
//  HOFFER
//
//  Created by JAM-E-214 on 24/04/24.
//  Copyright © 2024 JAM-E-214. All rights reserved.
//

struct LoginRequest:Encodable {
    var email:String
    var password:String
}

struct  LoginModel: Codable{
    var code:String
    var message:String
    var token:String?
    var data :  LoginModelData?
    
    init(_ JSON : [String:Any]){
        code   = checkForNilAndNull(dictionary: JSON, key: "code") ? "\(JSON["code"]!)" : ""
        message   = checkForNilAndNull(dictionary: JSON, key: "message") ? "\(JSON["message"]!)" : ""
        token   = checkForNilAndNull(dictionary: JSON, key: "token") ? "\(JSON["token"]!)" : ""
        data = LoginModelData((JSON["data"] != nil && JSON["data"] is [String : Any] && (JSON["data"] as! [String : Any]).count > 0 ? JSON["data"] as! [String : Any] : [String : Any]()))
        
    }
}


struct LoginModelData:Codable {
    var id:Int
    var username:String
    var email:String
    var avatar:String
    var trailer_no:String
    var status:Int
    var role:Int
    var device_token:String
    init(_ JSON : [String:Any]){
        id   = checkForNilAndNull(dictionary: JSON, key: "id") ? Int("\(JSON["id"]!)") ?? 0 : 0
        username   = checkForNilAndNull(dictionary: JSON, key: "username") ? "\(JSON["username"]!)" : ""
        email   = checkForNilAndNull(dictionary: JSON, key: "email") ? "\(JSON["email"]!)" : ""
        avatar   = checkForNilAndNull(dictionary: JSON, key: "avatar") ? "\(JSON["avatar"]!)" : ""
        trailer_no   = checkForNilAndNull(dictionary: JSON, key: "trailer_no") ? "\(JSON["trailer_no"]!)" : ""
        status   = checkForNilAndNull(dictionary: JSON, key: "status") ? Int("\(JSON["status"]!)") ?? 0 : 0
        role   = checkForNilAndNull(dictionary: JSON, key: "role") ? Int("\(JSON["role"]!)") ?? 0 : 0
        device_token   = checkForNilAndNull(dictionary: JSON, key: "device_token") ? "\(JSON["device_token"]!)" : ""
    
    }
}
