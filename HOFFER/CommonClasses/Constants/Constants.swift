//
//  Constants.swift
//  HOFFER
//
//  Created by SiliconMac on 25/07/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit

struct FeatureFlags {
    //TODO:- MAKE SURE TWO VARIABLE IS FALSE WHEN RELEASE
    static let isDebugClientDesk = false  // TRUE WHEN DEBUG ON CLIENT DESK WITH BLE DEVICE.
    static let isBypassForScreen = false
}

struct kUserDefault {
    static let deviceLists = "k_devicesLists"
    static let savedTickets = "k_save_ticketsLists"
}

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}


//=================================== User Detail ===================================//

var isUserLogin : Bool {
    return UserDefaults.standard.bool(forKey: "isUserLogin")
}

var dicUserDetail : NSMutableDictionary {
	return UserDefaults.standard.value(forKey: "userDetail") != nil ? UserDefaults.standard.value(forKey: "userDetail")  as? NSMutableDictionary ?? NSMutableDictionary() : NSMutableDictionary()
}

var strDefaultPin : String {
    return UserDefaults.standard.value(forKey: "mainPinCode") != nil ? "\(UserDefaults.standard.value(forKey: "mainPinCode") ?? "0000")" : "0000"
}

let strBackDoorPin           = "2009" //LIVE

//=================================== APIs ===================================//


//let strServerURL          = "http://192.168.1.42/work/hoffer/"     //Local
//let strServerURL          = "http://hoffer.siliconithub.com/"      //Testing
let strServerURL            = "http://hoffer.betaplanets.com/"              //LIVE

let strWebServiceURL        = "\(strServerURL)api/v1/"                      //LIVE

let strMediaURL             = "\(strServerURL)public/media/signature/"      //LIVE

let strApiKey               = "HoFfeR%4060918"                              //LIVE

let strApiDeleteTicket      = "tickets/delete/"
let strApiLogin             = "users/login"
let strApiSavedTicketList   = "tickets/list/"
let strApiSaveTicket        = "tickets/add/"
let strApiSendEmail         = "tickets/sendmail/"
let strApi_GetDeviceNames   = "users/get_devices"
let strApi_SetDeviceNames   = "users/edit_devices"

//=================================== Dialogue Alerts ===================================//


let strAskForDelete             = "Are you sure want to delete ticket?"
let strDeleteTicket             = "Ticket deleted successfully."
let strTicketSavedSuccess       = "Ticket saved successfully."
let strEmailSentSuccess         = "Email sent successfully."

let strTryAgain                 = "Something went wrong, try again later"
let strSearchPlaceHolder        = "Search...";
let strTimeOut                  = "Connection timeout, please check internet connectivity.";
let strNoEmail                  = "Please provide email address.";
let strNoPin                    = "Please Enter 4 Digit PIN.";
let strPinValidation            = "4 Digit Pin is required.";
let strPinChangeSuccess         = "PIN Changed Successfully.";
let strWrongPin                 = "Invalid PIN.";
let strNoPersonName             = "Please provide Person Name.";
let strInvalidEmail             = "Please provide valid Email address.";
let strNoPassword               = "Please provide password.";
let strForgotPassword           = "FORGOT PASSWORD?";
let strInvalidPassword          = "Password should have minmum 8 characters.";
let strNewPasswordSent          = "Your password has been sent successfully to your Email address.";
let strPasswordChange           = "Your password has been changed successfully.";
let strNoFName                  = "Please provide first name.";
let strNoLName                  = "Please provide last name.";
let strLogoutAlert              = "Are you sure want to logout?";
let strAgreeTC                  = "Please agree for Terms & Conditions.";
let strNoInternet               = "App cannot detect any Internet connectivity. Please check your Internet connection and try again.";

//MONITORING DELIVERY FOR US COMMAND ERRORS
let arrICEErrors                = [ "Command too long",
                                    "Incorrect command",
                                    "Incomplete command",
                                    "Clock setting error",
                                    "Input out of range",
                                    "Program error",
                                    "Pulse output out of range",
                                    "Flash segment1 invalid",
                                    "Flash segment2 invalid",
                                    "Total rollover",
                                    "Rate exceeds display",
                                    "Analog out exceeds 20 mA setting",
                                    "MAXINPUTFREQ exceeded",
                                    "Gas Present, Totalization Stopped",
                                    "Gas Warning",
                                    "Low Battery",
                                    "High Pressure Warning",
                                    "Temperature Short",
                                    "Temperature Open",
                                    "High Flow",
                                    "Low Flow",
                                    "Flowmeter coil open",
                                    "Flowmeter coil shorted",
                                    "Pressure sensor fail",
                                    "Pressure overrange",
                                    "Minimum delivery not reached",
                                    "Printer paper error",
                                    "Printer off-line",
                                    "Password error",
                                    "Input power low",
                                    "Missing Pulses Present",
                                    "Missing Pulses Exceed Limit"]

/*
 bit0 command too long
 bit1 incorrect command
 bit2 incomplete command
 bit3 clock setting error
 bit4 input out of range
 bit5 program error
 bit6 pulse output out of range
 bit7 flash segment1 invalid
 bit8 flash segment2 invalid
 bit9 total rollover
 bit10 rate exceeds display
 bit11 analog out exceeds 20 mA setting
 bit12 MAXINPUTFREQ exceeded
 bit 13 Gas Present, Totalization Stopped
 bit 14 Gas Warning
 bit 15 Low Battery
 bit 16 High Pressure Warning
 bit 17 Temperature Short
 bit 18 Temperature Open
 bit 19 High Flow
 bit 20 Low Flow
 bit 21 Flowmeter coil open
 bit 22 Flowmeter coil shorted
 bit 23 Pressure sensor fail
 bit 24 Pressure overrange
 bit 25 Minimum delivery not reached
 bit 26 Printer paper error
 bit 27 Printer off-line
 bit 28 Password error
 bit 29 Input power low
 bit 30 Missing Pulses Present
 bit 31 Missing Pulses Exceed Limit
 */
