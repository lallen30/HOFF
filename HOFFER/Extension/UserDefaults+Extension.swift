//
//  UserDefaults+Extension.swift
//  HOFFER
//
//  Created by JAM-E-214 on 24/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    
    static var password:String {
        set(input){
            self.standard.setValue(input, forKey: "password")
        }
        get{
            return self.standard.value(forKey: "password") as? String ?? ""
        }
    }
    static var linkedSpotify:Bool {
        set(input){
            self.standard.setValue(input, forKey: "linkedSpotify")
        }
        get{
            
            return self.standard.value(forKey: "linkedSpotify") as? Bool ?? false
        }
    }
    static var linkedAppleMusic:Bool {
        set(input){
            self.standard.setValue(input, forKey: "linkedAppleMusic")
        }
        get{
            
            return self.standard.value(forKey: "linkedAppleMusic") as? Bool ?? false
        }
    }
    static var admin:Bool {
        set(input){
            self.standard.setValue(input, forKey: "admin")
        }
        get{
            
            return self.standard.value(forKey: "admin") as? Bool ?? false
        }
    }
    static var host:Bool {
        set(input){
            self.standard.setValue(input, forKey: "host")
        }
        get{
            
            return self.standard.value(forKey: "host") as? Bool ?? false
        }
    }
    
    static var accessToken:String {
        set(input){
            self.standard.setValue(input, forKey: "access_token1")
        }
        get{
            return self.standard.value(forKey: "access_token1") as? String ?? ""
        }
    }
    static var accessTokenS:String {
        set(input){
            self.standard.setValue(input, forKey: "access_token")
        }
        get{
            return self.standard.value(forKey: "access_token") as? String ?? ""
        }
    }
    
    static var stayLoggedIn:Bool {
        set(input){
            self.standard.setValue(input, forKey: "stayLoggedIn")
        }
        get{
            return self.standard.value(forKey: "stayLoggedIn") as? Bool ?? true
        }
    }
    
    static var profileURL:String {
        set(input){
            self.standard.setValue(input, forKey: "img_Url")
        }
        get{
            return self.standard.value(forKey: "img_Url") as? String ?? ""
        }
    }
    static var userRole:String {
        set(input){
            self.standard.setValue(input, forKey: "user_Role")
        }
        get{
            return self.standard.value(forKey: "user_Role") as? String ?? ""
        }
    }
    static var gameType:String {
        set(input){
            self.standard.setValue(input, forKey: "game_type")
        }
        get{
            return self.standard.value(forKey: "game_type") as? String ?? ""
        }
    }
    static var newCategory:String {
        set(input){
            self.standard.setValue(input, forKey: "new_category")
        }
        get{
            return self.standard.value(forKey: "new_category") as? String ?? ""
        }
    }
    static var baseUrl:String {
        set(input){
            self.standard.setValue(input, forKey: "base_Url")
        }
        get{
            return self.standard.value(forKey: "base_Url") as? String ?? ""
        }
    }
    static var lastEmail:String {
        set(input){
            self.standard.setValue(input, forKey: "lastEmail")
        }
        get{
            return self.standard.value(forKey: "lastEmail") as? String ?? ""
        }
    }
    static var refreshToken:String {
        set(input){
            self.standard.setValue(input, forKey: "refresh_token")
        }
        get{
            return self.standard.value(forKey: "refresh_token") as? String ?? ""
        }
    }
    static var firebaseToken:String {
        set(input){
            self.standard.setValue(input, forKey: "firebase_token")
        }
        get{
            return self.standard.value(forKey: "firebase_token") as? String ?? ""
        }
    }
    static var deviceId:String {
        set(input){
            self.standard.setValue(input, forKey: "deviceId")
        }
        get{
            return self.standard.value(forKey: "deviceId") as? String ?? ""
        }
    }
    
    static var timeInterval:Int {
        set(input){
            self.standard.setValue(input, forKey: "deviceId")
        }
        get{
            return self.standard.value(forKey: "deviceId") as? Int ?? 0
        }
    }
    
    static var userData:Data {
        set(input){
            self.standard.setValue(input, forKey: "userData")
        }
        get{
            
            return self.standard.value(forKey: "userData") as! Data
        }
    }
    
    static var settingData:Data {
        set(input){
            self.standard.setValue(input, forKey: "settingData")
        }
        get{
            
            return self.standard.value(forKey: "settingData") as! Data
        }
    }
    static var Houtlet:String {
        set(input){
            self.standard.setValue(input, forKey: "Houtlet")
        }
        get{
            return self.standard.value(forKey: "Houtlet") as? String ?? ""
        }
    }
    
    static var walkThroughEnabled:String {
        set(input){
            self.standard.setValue(input, forKey: "walkThroughEnabled")
        }
        get{
            return self.standard.value(forKey: "walkThroughEnabled") as? String ?? ""
        }
    }
    
    static var userName:String{
        set(input){
            self.standard.setValue(input, forKey: "userName")
        }
        get{
            
            return self.standard.value(forKey: "userName") as? String ?? ""
        }
    }
    
    static var userId:Int{
        set(input){
            self.standard.setValue(input, forKey: "userId")
        }
        get{
            
            return self.standard.value(forKey: "userId") as? Int ?? 0
        }
    }
    
    static var gameId:String{
        set(input){
            self.standard.setValue(input, forKey: "gameId")
        }
        get{
            
            return self.standard.value(forKey: "gameId") as? String ?? ""
        }
    }

    static var userEmail:String{
        set(input){
            self.standard.setValue(input, forKey: "userEmail")
        }
        get{
            
            return self.standard.value(forKey: "userEmail") as? String ?? ""
        }
    }
    static var userPhone:String{
        set(input){
            self.standard.setValue(input, forKey: "userPhone")
        }
        get{
            
            return self.standard.value(forKey: "userPhone") as? String ?? ""
        }
    }
    
    
//    static var userDetails:loginModel{
//        set(input){
//            self.standard.setValue(input, forKey: "userDetails")
//        }
//        get{
//
//            return self.standard.value(forKey: "userDetails") as? loginModel ?? loginModel([String : Any]())
//        }
//    }



}
