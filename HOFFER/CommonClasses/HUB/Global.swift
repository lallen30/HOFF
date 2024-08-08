//
//  Global.swift
//  Marijanego Customer
//
//  Created by Silicon IT Hub. on 1/5/17.
//  Copyright © 2017 Silicon IT Hub. All rights reserved.
//
import UIKit
class Global {
    
    static let DeviceUUID = UIDevice.current.identifierForVendor!.uuidString
    static let PhoneDigitLimit = 11
    static let UserNameDigitLimit = 50
    static let StreetNODigitLimit = 20
    static let StreetNameDigitLimit = 60

    static var IsOffline:Bool = false
    
    struct g_ws {
        static let Device_type: Int! = 2
    }
    
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    static var lastPhone:String = ""
    static var lastpass:String = ""
    static var lastrepass:String = ""
    
    
    //Device Compatibility
    struct is_Device {
        static let _iPhone = (UIDevice.current.model as String).isEqual("iPhone") ? true : false
        static let _iPad = (UIDevice.current.model as String).isEqual("iPad") ? true : false
        static let _iPod = (UIDevice.current.model as String).isEqual("iPod touch") ? true : false
    }
    
    //Display Size Compatibility
    struct is_iPhone {
        static let _X = (UIScreen.main.bounds.size.height == 812.0 ) ? true : false //2436
        static let _6p = (UIScreen.main.bounds.size.height >= 736.0 ) ? true : false
        static let _6 = (UIScreen.main.bounds.size.height <= 667.0 && UIScreen.main.bounds.size.height > 568.0) ? true : false
        static let _5 = (UIScreen.main.bounds.size.height <= 568.0 && UIScreen.main.bounds.size.height > 480.0) ? true : false
        static let _4 = (UIScreen.main.bounds.size.height <= 480.0) ? true : false
    }
    
    //IOS Version Compatibility
    struct is_iOS {
        static let _11 = ((Float(UIDevice.current.systemVersion as String))! >= Float(11.0)) ? true : false
        static let _10 = ((Float(UIDevice.current.systemVersion as String))! >= Float(10.0)) ? true : false
        static let _9 = ((Float(UIDevice.current.systemVersion as String))! >= Float(9.0) && (Float(UIDevice.current.systemVersion as String))! < Float(10.0)) ? true : false
        static let _8 = ((Float(UIDevice.current.systemVersion as String))! >= Float(8.0) && (Float(UIDevice.current.systemVersion as String))! < Float(9.0)) ? true : false
    }
    
    // MARK: - Shared classes
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let singleton = Singleton.sharedSingleton

    // MARK: - Database Name
    static let g_Databasename = "MarijaneGo"
    
    // MARK: - Screen size
    static let screenWidth : CGFloat = (APPDELEGATE.window!.bounds.size.width)
    static let screenHeight : CGFloat = (APPDELEGATE.window!.bounds.size.height)
    
    // MARK: - Get UIColor from RGB
    public func RGB(r: Float, g: Float, b: Float, a: Float) -> UIColor {
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a))
    }
    
    // MARK: - Dispatch Delay
    func delay(delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

   // MARK: - Application Colors
   struct kAppColor {
        static let PrimaryTheme =  #colorLiteral(red: 0.1254901961, green: 0.2431372549, blue: 0.5176470588, alpha: 1)   //Global().RGB(r: 212.0, g: 87.0, b: 57.0, a: 1.0)
        static let StatusColor =  #colorLiteral(red: 0.7098039216, green: 0.262745098, blue: 0.1490196078, alpha: 1)   //Global().RGB(r: 181.0, g: 67.0, b:38.0, a: 1.0)
    
        static let ButtonColor =  #colorLiteral(red: 0.1254901961, green: 0.2431372549, blue: 0.5176470588, alpha: 1)
    
        static let DarkGray =  #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)     //Global().RGB(r: 68.0, g: 68.0, b:68.0, a: 1.0)
        static let LightGray =  #colorLiteral(red: 0.3215686275, green: 0.3215686275, blue: 0.3215686275, alpha: 1)    //Global().RGB(r: 52.0, g: 52.0, b:52.0, a: 1.0)
        static let ErrorColor =  #colorLiteral(red: 0.7098039216, green: 0.01254251701, blue: 0.1490196078, alpha: 1)
        static let WhiteColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
        static let GreenColor =  #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        static let RedColor =  #colorLiteral(red: 1, green: 0.08235294118, blue: 0.09803921569, alpha: 1)
        static let BlueColor =  #colorLiteral(red: 0.2588235294, green: 0.5215686275, blue: 0.9568627451, alpha: 1)
    
        static let SecondaryGrey =  #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        static let SecondaryBlue365188 =  #colorLiteral(red: 0.2117647059, green: 0.3176470588, blue: 0.5333333333, alpha: 1)
        static let SecondaryBlue4059 =  #colorLiteral(red: 0.2509803922, green: 0.3490196078, blue: 0.5607843137, alpha: 1)
        static let SecondaryWightF7 =  #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        static let SecondaryWightF1E =  #colorLiteral(red: 0.9450980392, green: 0.937254902, blue: 0.9411764706, alpha: 0.796403104) // for place holder
        static let SecondaryCopyWightF1E =  #colorLiteral(red: 0.9450980392, green: 0.937254902, blue: 0.9411764706, alpha: 1)
        static let SecondaryRed =  #colorLiteral(red: 0.831372549, green: 0.3411764706, blue: 0.2235294118, alpha: 1)
   }

    // MARK: -Application Fonts
    struct kFont {
        static let Helvetica_Regular = "Helvetica-Regular"
        static let Helvetica_Bold = "Helvetica-Bold"
        static let Helvetica_BoldOblique = "Helvetica-Bold Oblique"
        static let Helvetica_Light = "Helvetica-Light"
        static let Helvetica_LightOblique = "Helvetica-Light Oblique"
        static let Helvetica_Oblique = "Helvetica-Oblique"
    }

    struct kFontSize {
        static let  TextFieldSmallSize_8:CGFloat = 8
        static let  TextFieldSize:CGFloat = 14
        static let  ButtonSize:CGFloat = 15
        static let  LabelSize:CGFloat = 14
    }
    
    struct abbreviation {
        //static var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation()!.keepNumericsOnly ?? "" }
    }
    
    struct g_UserDefaultKey {
        static let DeviceToken: String! = "DEVICE_TOKEN"
    }
    
    func getDeviceSpecificFontSize(_ fontsize: CGFloat) -> CGFloat {
        return ((Global.screenWidth) * fontsize) / 320
    }
    
    struct is_Reachablity {
        var isNetwork = Global.singleton.isConnectivityChecked()
    }
    
//    func getLocalizeStr(key: String) -> String {
//        return LocalizeHelper.sharedLocalSystem().localizedString(forKey: key)
//    }

    // MARK: - User Data
    struct kLoggedInUserKey {
        static let Pref_IsLoggedIn: String! = "Pref_IsDriverLoggedIn"
        
        static let Pref_Customer_Id: String! = "Pref_Customer_Id"
        static let Pref_Customer_avatar: String! = "Pref_Customer_Avatar"
        
        static let Pref_Customer_Firstname: String! = "Pref_Customer_FirstName"
        static let Pref_Customer_Lastname:String = "Pref_Customer_LastName"
        static let Pref_Customer_Email: String! = "Pref_Customer_Email"
        static let Pref_Customer_Phone: String! = "Pref_Customer_Phone"
    }
    
    // MARK: - String Type for Validation
    enum kStringType : Int {
        case AlphaNumeric
        case AlphabetOnly
        case NumberOnly
        case Fullname
        case Username
        case Email
        case PhoneNumber
    }
    
    // MARK: - Post Media Type
    struct kGoogleApiKey {
        static let strPlaceAPIKey = "AIzaSyBlwDGf2y197x-6VRDYRU20BwvBxmn_aY4"
    }
    
    struct kGoogleApis {
        static let strContactApi = "https://www.googleapis.com/auth/contacts.readonly"
    }
    
    // MARK: - Create Post: Text Theme Colors
    struct kTextThemeColor {
        static let Start_1 = Global().RGB(r: 248, g: 248, b: 141, a: 1).cgColor
        static let End_1 = Global().RGB(r: 248, g: 248, b: 141, a: 1).cgColor
        
        static let Start_2 = Global().RGB(r: 86, g: 229, b: 159, a: 1).cgColor
        static let End_2 = Global().RGB(r: 40, g: 187, b: 230, a: 1).cgColor
        
        static let Start_3 = Global().RGB(r: 74, g: 144, b: 226, a: 1).cgColor
        static let End_3 = Global().RGB(r: 74, g: 144, b: 226, a: 1).cgColor
        
        static let Start_4 = Global().RGB(r: 220, g: 56, b: 246, a: 1).cgColor
        static let End_4 = Global().RGB(r: 97, g: 63, b: 219, a: 1).cgColor
        
        static let Start_5 = Global().RGB(r: 243, g: 83, b: 105, a: 1).cgColor
        static let End_5 = Global().RGB(r: 243,g: 83, b: 105, a: 1).cgColor
        
        static let Start_6 = Global().RGB(r: 252, g: 209, b: 114, a: 1).cgColor
        static let End_6 = Global().RGB(r: 244, g: 89, b: 106, a: 1).cgColor
        
        static let Start_7 = Global().RGB(r: 137, g: 250, b: 147, a: 1).cgColor
        static let End_7 = Global().RGB(r: 137, g: 250, b: 147, a: 1).cgColor
        
        static let Start_8 = Global().RGB(r: 255, g: 150, b: 225, a: 1).cgColor
        static let End_8 = Global().RGB(r: 255, g: 150, b: 225, a: 1).cgColor
    }
    
    //DatabaseKey
    struct DatabaseKey {
        static let STATEDATA = "states";
        static let STATE_ID = "id";
        static let STATE_NAME = "name";
        static let STATE_COUNTRY_ID = "country_id";
        
        static let CARDATA = "car_types";
        static let CAR_ID = "id";
        static let CAR_NAME = "name";
        
        static let DOCUMENTSDATA = "documents";
        static let DOCUMENT_ID = "id";
        static let DOCUMENT_NAME = "name";
    }
    
}
