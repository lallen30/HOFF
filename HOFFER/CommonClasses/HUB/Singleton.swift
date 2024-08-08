//
//  Singleton.swift
//  chilax
//
//  Created by Self on 6/13/17.
//  Copyright © 2017 All rights reserved.
//

import UIKit
import SpinKit
import Foundation

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}   

class DeviceModel: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(strID, forKey: "id")
        aCoder.encode(strName, forKey: "name")
        aCoder.encode(strUUID, forKey: "uuid")
        aCoder.encode(strMacID, forKey: "macid")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        let uid = aDecoder.decodeObject(forKey: "uuid") as? String ?? ""
        let mid = aDecoder.decodeObject(forKey: "macid") as? String ?? ""
        let name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.init(id: id, name: name, UUID: uid, macid: mid)
    }
    
    var strID :String = ""
    var strName :String = ""
    var strUUID :String = ""
    var strMacID :String = ""
    
    init(id:String,name:String,UUID:String,macid:String) {
        self.strID = id
        self.strName = name
        self.strUUID = UUID
        self.strMacID = macid
    }
}

class Singleton: NSObject {
    
    enum status {
        case on
        case off
    }
    
    static let sharedSingleton = Singleton()

    var is_presented = false
    var is_PeopleDetailsVC = false
    var intIsNewInsertRecord : Int = 0
    var viewLoader: UIView?
    var is_FromSocialLogin:Bool = false
    var is_FromMyAddress:Bool = false
    var selectedPeripheral: BlePeripheral?
    
    var arrDevicesNames : [DeviceModel] {
        get {
            if let data = Singleton.sharedSingleton.retriveCustomObjectFromUserDefaults(key: kUserDefault.deviceLists) as? Data {
                if let arr = NSKeyedUnarchiver.unarchiveObject(with: data) as? [DeviceModel] {
                    return arr
                }
            }
             return []
        }
    }
    
    var arrSavedTicket : [NSMutableDictionary] {
        get {
            if let data = UserDefaults.standard.object(forKey: kUserDefault.savedTickets) as? [NSMutableDictionary] {
                return data
            }
            return []
        }
    }
    
    func deleteLocalRecoard(strName:String) {
        let manager = FileManager.default
        if manager.isDeletableFile(atPath: "\(getDocumentDirPath())/\(strName)") {
            do {
                try manager.removeItem(atPath: "\(getDocumentDirPath())/\(strName)")
            } catch {
                return
            }
        }
    }
    
    func isConnectivityChecked()-> Bool {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            return true
        } else  {
            return false
        }
    }
    
    func showAlertWithDoubleButton(){
        AJAlertController.initialization().showAlert(aStrMessage: "This is Alert message with two buttons", aCancelBtnTitle: "NO", aOtherBtnTitle: "YES") { (index, title) in
            print(index,title)
        }
    }
    
    func showAlertWithSingleButton(strMessage : String){
        AJAlertController.initialization().showAlertWithOkButton(aStrMessage: strMessage) { (index, title) in
            //print(index,title)
        }
    }
    
    func showErrorWithSingleButton(strMessage : String){
        AJAlertController.initialization().showRedAlertWithOkButton(aStrMessage: strMessage) { (index, title) in
            //print(index,title)
        }
    }
    //MARK: - APP STATE:
    func isAppLaunchedFirst()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnceMode"){
            print("App already launched ")
            return false
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnceMode")
            print("App launched first time")
            return true
        }
    }
    
    //MARK: - Corner Radius:
    func setCornerRadius(view:UIView, radius:CGFloat) {
        view.layer.cornerRadius = radius
    }
    
    func localToPST(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    func localToPSTT(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    func PSTToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss, MM:dd:yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm:ss, MM:dd:yyyy"
        
        return dateFormatter.string(from: dt!)
    }
    
    // MARK: JSON Conversation
    func GetArrayfromJson(Json:String) -> [AnyObject] {
        var arrObjects:[AnyObject] = []
        if let data = Json.data(using: String.Encoding.utf8) {
            do{
                if let arrayOfInts = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                    print(arrayOfInts)
                    arrObjects = arrayOfInts
                }
            }
            catch{
                print("errro")
            }
        }
        return arrObjects
    }
    
    func GetDictionaryfromJson(Json:String) -> [String:String] {
        var arrObjects:[String:String] = [:]
        if let data = Json.data(using: String.Encoding.utf8) {
            do{
                if let arrayOfInts = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:String] {
                    print(arrayOfInts)
                    arrObjects = arrayOfInts
                }
            }
            catch{
                print("errro")
            }
        }
        return arrObjects
    }
    
    //MARK:- SET DEVICES NAMES:-
    func setDevicesName(_ strName:String, strUUID:String, successBlock: @escaping () -> Void,failureBlock: @escaping () -> Void){
        
        let urlParameters = "?name=\(strName)&udid=\(strUUID)&user_id=\(dicUserDetail.value(forKey: "user_id") ?? "0")&api_key:\(strApiKey)".urlEncodeString()
        
        let _ = AkWebServiceCall().CallApiWithPath(path: strApi_SetDeviceNames + urlParameters, input: NSDictionary(), showLoader: false, view: UIView.init(), isGetMethod: true, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            
            print(dicResponse)
            if isSuccess
            {
                if dicResponse.value(forKey: "code") as! String == "0"
                {
                    var isFound: Bool = false
                    let arrTempArray = Singleton.sharedSingleton.arrDevicesNames
                    for aDevice in arrTempArray {
                        if aDevice.strUUID == strUUID {
                            aDevice.strName = strName // SET DEVICE NAME HERE
                            isFound = true
                            break
                        }
                    }
                    if !isFound{
                        let aDevice = DeviceModel(id: "0", name: strName, UUID:strUUID, macid: "")
                        var arrTempArray = Singleton.sharedSingleton.arrDevicesNames
                        arrTempArray.append(aDevice)
                        let data  = NSKeyedArchiver.archivedData(withRootObject: arrTempArray)
                        Singleton.sharedSingleton.saveCustomObjectToUserDefaults(value: data, forKey: kUserDefault.deviceLists)
                    }else{
                        let data  = NSKeyedArchiver.archivedData(withRootObject: arrTempArray)
                        Singleton.sharedSingleton.saveCustomObjectToUserDefaults(value: data, forKey: kUserDefault.deviceLists)
                    }
                    successBlock()
                }
                else
                {
                    Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as? String ?? "Something went wrong")
                    failureBlock()
                }
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as? String ?? "Something went wrong")
                failureBlock()
            }
            
        }) { (dicResponse, isSuccess) in
            
            print(dicResponse)
            failureBlock()
            
        }

    }
    
    //MARK:- GET DEVICE NAMES
    func getDevicesList(successBlock: @escaping () -> Void,failureBlock: @escaping () -> Void){
        let _ = AkWebServiceCall().CallApiWithPath(path: strApi_GetDeviceNames, input: NSDictionary(), showLoader: false, view: UIView.init(), isGetMethod: true, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            
            print(dicResponse)
            if isSuccess
            {
                if dicResponse.value(forKey: "code") as! String == "0"
                {
                    //self.saveToJsonFile(dict: json)
                    if let arrDevices = dicResponse["devices"] as? [[String:Any]] {
                        var arrDevicesList : [DeviceModel] = []
                        //Singleton.sharedSingleton.arrDevicesNames.removeAll()
                        for element in arrDevices {
                            let aDevice = DeviceModel(id: String(element["id"] as? Int ?? 0), name: element["name"] as? String ?? "", UUID:element["udid"] as? String ?? "", macid: element["macid"] as? String ?? "")
                            //Singleton.sharedSingleton.arrDevicesNames.append(aDevice)
                            arrDevicesList.append(aDevice)
                        }
                        if arrDevicesList.count > 0 {
                            let data  = NSKeyedArchiver.archivedData(withRootObject: arrDevicesList)
                            Singleton.sharedSingleton.saveCustomObjectToUserDefaults(value: data, forKey: kUserDefault.deviceLists)
                        }
                    }
                    successBlock()
                }
                else
                {
                    failureBlock()
                }
            }
            else
            {
                failureBlock()
            }
            
        }) { (dicResponse, isSuccess) in
            
            print(dicResponse)
            failureBlock()
            
        }
        
        return;
        
        /*
        //https://stackoverflow.com/a/46895243/2910061
        let params = ["api_key":strApiKey] as Dictionary<String, String> //
        var request = URLRequest(url: URL(string: strWebServiceURL + strApi_GetDeviceNames)!) //webServiceURL + strApiSaveTicket
        request.httpMethod = "GET"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                if data != nil {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject> {
                        print(json)
                        //self.saveToJsonFile(dict: json)
                        if let arrDevices = json["devices"] as? [[String:Any]] {
                            Singleton.sharedSingleton.arrDevicesNames.removeAll()
                            for element in arrDevices {
                                let aDevice = DeviceModel(id: String(element["id"] as? Int ?? 0), name: element["name"] as? String ?? "", UUID:element["udid"] as? String ?? "", macid: element["macid"] as? String ?? "")
                                Singleton.sharedSingleton.arrDevicesNames.append(aDevice)
                            }
                        }
                        successBlock()
                    }else{
                        failureBlock()
                    }
                }
                else
                {
                    failureBlock()
                }
            } catch {
                print("error")
                failureBlock()
            }
        })
        
        task.resume()*/
    }
    
    //MARK:- SAVE FILES IN THE DOCUMENTS DIRECTORY
    func saveToJsonFile(dict:[String:Any]) {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Devices.json")
        //let personArray =  [["person": ["name": "Dani", "age": "24"]], ["person": ["name": "ray", "age": "70"]]]
        // Create a write-only stream
        guard let stream = OutputStream(toFileAtPath: fileUrl.path, append: false) else { return }
        stream.open()
        defer {
            stream.close()
        }
        
        // Transform array into data and save it into file
        var error: NSError?
        JSONSerialization.writeJSONObject(dict, to: stream, options: [], error: &error)
        // Handle error
        if let error = error {
            print(error)
        }
    }
    
    //MARK:- GET DEIVCE LIST FORM THE LOCAL DIRECTORY
    func retrieveFromJsonFile()->[DeviceModel] {
        // Get the url of Persons.json in document directory
        var arrValues :[DeviceModel] = []
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return arrValues }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Devices.json")
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return arrValues}
            print(json)
            if let arrDevices = json["devices"] as? [[String:Any]] {
                arrValues.removeAll()
                for element in arrDevices {
                    let aDevice = DeviceModel(id: String(element["id"] as? Int ?? 0), name: element["name"] as? String ?? "", UUID:element["udid"] as? String ?? "", macid: element["macid"] as? String ?? "")
                    arrValues.append(aDevice)
                }
            }
            return arrValues
        } catch {
            print(error)
            return arrValues
        }
    }
    
    func call_verifyUsers(_ strPassword:String, successBlock: @escaping () -> Void,failureBlock: @escaping () -> Void){
        let dicInput = NSMutableDictionary()
        dicInput.setValue(UserDefaults.standard.object(forKey: "email") as? String ?? "", forKey: "email");
        dicInput.setValue(strPassword, forKey: "password");
        
        let _ = AkWebServiceCall().CallApiWithPath(path: strApiLogin, input: dicInput, showLoader: true, view: Global.appDelegate.window!.rootViewController!.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            print(dicResponse)
            if isSuccess
            {
                if dicResponse.value(forKey: "code") as! String == "0"
                {
                    successBlock()
                }
                else
                {
                    Singleton().showAlertWithSingleButton(strMessage: "Invalid Credentials")
                    failureBlock()
                }
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: "Invalid Credentials")
                failureBlock()
            }
        }) { (dicResponse, isSuccess) in
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
            failureBlock()
        }
    }
    
    func conVertToJSONDictionary(jsonObject:[String: String])-> String {
        print("start time\(Date())")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            let data = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print("End time\(Date())")
            return data
        } catch {
            print(error.localizedDescription)
            return ""
        }
        
    }
    
    func conVertToJSONArray(jsonObject:NSMutableDictionary)-> String {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? ""
            
        } catch {
            print(error.localizedDescription)
            return ""
        }
        
    }
    
    func conVertToJSONArrayWithAnyObjects(jsonObject:[AnyObject])-> String {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? ""
            
        } catch {
            print(error.localizedDescription)
            return ""
        }
        
    }
    
    // MARK: - Skip Backup Attribute for File
    func addSkipBackupAttributeToItemAtURL(URL:NSURL) {
        assert(FileManager.default.fileExists(atPath: URL.path!))
        do {
            try URL.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
        }
        catch let error as NSError {
            print("Error excluding \(URL.lastPathComponent!) from backup \(error)");
        }
    }
    
    // MARK: - Device Specific Method
//    func getDeviceSpecificNibName(_ strNib: String) -> String {
//        if Global.is_iPhone._4 {
//            return strNib + ("_4")
//        }
//        else {
//            return strNib
//        }
//    }
    
    func getDeviceSpecificFontSize(_ fontsize: CGFloat) -> CGFloat {
        return ((Global.screenWidth) * fontsize) / 320
    }
    
    func saveCustomObjectToUserDefaults (value: Any, forKey key: String) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject:value)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
    }
    
    func retriveCustomObjectFromUserDefaults (key: String) -> Any {
        let defaults = UserDefaults.standard
        if let decoded = defaults.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: decoded) ?? ""
        }
        else{
            return ""
        }
    }
    
    // MARK: - UserDefaults Methods
    func saveToUserDefaults (value: String, forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value , forKey: key as String)
        defaults.synchronize()
    }
    
    func Numericalformat(count:Int) -> String {
        if count > 100000 {
            return String(Int(count / 1000))+"k"
        }
        else{
            return String(count)
        }
    }

    func retriveFromUserDefaults (key: String) -> String? {
        let defaults = UserDefaults.standard
        if let strVal = defaults.string(forKey: key as String) {
            return strVal
        }
        else{
            return "" as String?
        }
    }

    // MARK: - String RemoveNull and Trim Method
    func displayFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
    func removeNull (str:String) -> String {
        if (str == "<null>" || str == "(null)" || str == "N/A" || str == "n/a" || str.isEmpty) {
            return ""
        } else {
            return str
        }
    }
    
    func kTRIM(string: String) -> String {
        return string.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    // MARK: - Get string size Method
    func getSizeFromString (str: String, stringWidth width: CGFloat, fontname font: UIFont, maxHeight mHeight: CGFloat) -> CGSize {
		let rect : CGRect = str.boundingRect(with: CGSize(width: width, height: mHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil)
        return rect.size
    }
    
    func getSizeFromAttributedString (str: NSAttributedString, stringWidth width: CGFloat, maxHeight mHeight: CGFloat) -> CGSize {
        let rect : CGRect = str.boundingRect(with: CGSize(width: width, height: mHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.size
    }
    
    // MARK: - Attributed String
    func setStringLineSpacing(_ strText: String, floatSpacing: CGFloat, intAlign: Int) -> NSMutableAttributedString {
        //o=center  1=left = 2=right
        let attributedString = NSMutableAttributedString(string: strText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = floatSpacing
        if intAlign == 0 {
            paragraphStyle.alignment = .center
        }
        else if intAlign == 1 {
            paragraphStyle.alignment = .left
        }
        else {
            paragraphStyle.alignment = .right
        }
		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: (strText.count )))
        return attributedString
    }
    
    /*func setButtonStringChilaxFontBaseLine(_ strText: String, floatIconFontSize:CGFloat, floatTextFontSize: CGFloat, floatBase: CGFloat, intIconPos: Int) -> NSMutableAttributedString { //first character Chilax font and other all GothamBook font
        let attributedString = NSMutableAttributedString(string: strText)
        if (intIconPos == 1) {//first character icon
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Global.kFont.QWALLIcon, size: Global.singleton.getDeviceSpecificFontSize(floatIconFontSize))!, range: NSRange(location: 0, length: 1))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Global.kFont.QuicksandRegular, size: Global.singleton.getDeviceSpecificFontSize(floatTextFontSize))!, range: NSRange(location: 1, length: strText.characters.count-1))
            attributedString.addAttribute(NSBaselineOffsetAttributeName, value: Global.singleton.getDeviceSpecificFontSize(floatBase), range: NSRange(location: 1, length: strText.characters.count-1))
        }
        else if (intIconPos == 2) {//last character icon
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Global.kFont.QuicksandRegular, size: Global.singleton.getDeviceSpecificFontSize(floatTextFontSize))!, range: NSRange(location: 0, length: strText.characters.count-1))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Global.kFont.QWALLIcon, size: Global.singleton.getDeviceSpecificFontSize(floatIconFontSize))!, range: NSRange(location: strText.characters.count-1, length: 1))
            attributedString.addAttribute(NSBaselineOffsetAttributeName, value: Global.singleton.getDeviceSpecificFontSize(floatBase), range: NSRange(location: 0, length: strText.characters.count-2))
        }
        return attributedString;
    }*/
    
    func removeShadow(to view:UIView) {
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.0
    }
  
    func setShadow(to view:UIView) {
        //let shadowSize : CGFloat = 2.0
        ////view.layer.frame = view.bounds
        //let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
        //                                           y: -shadowSize / 2,
        //                                           width: view.frame.size.width + shadowSize,
        //                                           height: view.frame.size.height + shadowSize))
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0).cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        view.layer.shadowOpacity = 0.3
        //view.layer.shadowPath = shadowPath.cgPath
    }
    
    func setBottomShadow(to view:UIView) {
        let shadowSize : CGFloat = 2.0
        //view.layer.frame = view.bounds
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: view.frame.size.width + shadowSize,
                                                   height: view.frame.size.height + shadowSize))
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowPath = shadowPath.cgPath
    }
    
    // MARK: - TextField Validation Method
    func validateEmail(strEmail: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: strEmail)
    }
    
    func validatePhoneNumber(strPhone: String) -> Bool {
        let phoneRegex: String = "[0-9]{8}([0-9]{1,3})?"
        let test = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return test.evaluate(with: strPhone)
    }
    
    
    //MARK: -  PARSE LOGIN DATA
    func parseLoginUserData(dic:NSDictionary) -> Void {
        Singleton.sharedSingleton.saveToUserDefaults(value: String(dic.object(forKey:"customer_id") as! Int64) , forKey: Global.kLoggedInUserKey.Pref_Customer_Id)
        Singleton.sharedSingleton.saveToUserDefaults(value: dic.object(forKey:"firstname") as? String ?? "" , forKey: Global.kLoggedInUserKey.Pref_Customer_Firstname)
        Singleton.sharedSingleton.saveToUserDefaults(value: dic.object(forKey:"lastname") as? String ?? "" , forKey: Global.kLoggedInUserKey.Pref_Customer_Lastname)
        Singleton.sharedSingleton.saveToUserDefaults(value: dic.object(forKey:"email") as? String ?? "" , forKey: Global.kLoggedInUserKey.Pref_Customer_Email)
        Singleton.sharedSingleton.saveToUserDefaults(value: dic.object(forKey:"phone") as? String ?? "" , forKey: Global.kLoggedInUserKey.Pref_Customer_Phone)
        Singleton.sharedSingleton.saveToUserDefaults(value: dic.object(forKey:"avatar") as? String ?? "" , forKey: Global.kLoggedInUserKey.Pref_Customer_avatar)
    }
    
    // MARK: - get Directory Path
    func getDocumentDirPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return documentsPath //self.arrDeliveryTicketData[indexPath.row] as! String)
    }
    
    //MARK: TIME FORMAT
    func TimeFormatter_12H() -> DateFormatter {
        //06:35 PM
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }
    
    func TimeFormatter_24_H() -> DateFormatter {
        //19:29:50
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
    func TimeFormatter_24_H_M() -> DateFormatter {
        //19:29
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    func ConvertStrintoDate(dateStr:String) -> Date? {
        if dateStr == ""
        {
            return nil
        }
        let date = Singleton.sharedSingleton.dateFormatterYYYYMMDD().date(from: dateStr)
        return date
    }
    
    //MARK: DATE FORMAT
    func dateFormatterOnlyTime() -> DateFormatter {
        //19:29:50
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
    
    func dateFormatterFullWithTimeZone() -> DateFormatter {
        //2016-10-24 19:29:50 +0000
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
    func dateFormatterFull_MDY_HMS_SocialDisplay() -> DateFormatter {
        //2017-05-25 00:05:13
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
        return dateFormatter
    }
    
    func dateFormatterFull_YMD_HMS() -> DateFormatter {
        //2017-05-25 00:05:13
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
    func dateFormatter() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    func dateFormatterForDisplay() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter
    }
    func dateFormatterMMDDYYY() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }
    func dateFormatterDDMMYYY() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    func dateFormatterDDMMYY() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }
    
    func dateFormatterYYYYMMDD() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    func dateFormatterMMMMddyyyy() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        return dateFormatter
    }
    
    func dateFormatterForDisplay_DMMMY() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter
    }
    func dateFormatterForCall() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    func dateFormatterForYearOnly() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }
    func dateFormatterForMonthINNumberOnly() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter
    }
    func dateFormatterForDaysMonthsYears() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, d LLL yyyy"
        return dateFormatter
    }
    func dateFormatterForYMD_T_HMSsss() -> DateFormatter {
        //yyyy-MM-dd'T'HH:mm:ss.SSS        
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return dateFormatter
    }
    
    func dateFormatterForYMD_T_HMS() -> DateFormatter {
        //yyyy-MM-dd'T'HH:mm:ss
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    func dateFormatterForUniqueName() -> DateFormatter {
        //yyyy-MM-dd'T'HH:mm:ss
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter
    }
    
    
    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        // calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
        return calendar.date(from: components)!
    }
    
    func calculateAgefromDateString(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    //MARK:-  get Country JSon array
    func getCountryCodeJsonDataArray() -> NSArray {
        do {
            let countrydata: Data = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "CountryCode", ofType: "json")!))
            do {
                if let arrData: NSArray = try JSONSerialization.jsonObject(with: countrydata, options: []) as? NSArray {
                    return arrData
                }
            } catch {
            }
        }
        catch {
        }
        return NSArray()
    }
    
    // convert images into base64 and keep them into string
    
    func convertImageToBase64(image: UIImage) -> String {
        
		let imageData = image.pngData()
        let base64Str = imageData?.base64EncodedString()
        
        
        return base64Str!
        
    }
    
    // convert images into base64 and keep them into string
    
    func convertBase64ToImage(base64String: String) -> UIImage {
        
        let decodedData = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0) )
        
        let decodedimage = UIImage(data: decodedData! as Data)
        
        return decodedimage!
        
    }
    
    //MARK:- NUMERICAL TO TEXT CONVERTED
    
    func GetNumericalMonthFromText(strMonth:String) -> String{
        if strMonth == "Jan" || strMonth == "jan" {
            return "1"
        }else if strMonth == "Feb" || strMonth == "feb" {
            return "2"
        }
        else if strMonth == "Mar" || strMonth == "mar" {
            return "3"
        }
        else if strMonth == "Apr" || strMonth == "apr" {
            return "4"
        }
        else if strMonth == "May" || strMonth == "may" {
            return "5"
        }
        else if strMonth == "Jun" || strMonth == "jun" {
            return "6"
        }
        else if strMonth == "Jul" || strMonth == "jul" {
            return "7"
        }
        else if strMonth == "Aug" || strMonth == "aug" {
            return "8"
        }
        else if strMonth == "Sep" || strMonth == "sep" {
            return "9"
        }
        else if strMonth == "Oct" || strMonth == "oct" {
            return "10"
        }
        else if strMonth == "Nov" || strMonth == "nov" {
            return "11"
        }
        else if strMonth == "Dec" || strMonth == "dec" {
            return "12"
        }else{
            return strMonth
        }
    }
    
    func GetTextToNumericalMonth(strMonth:String) -> String{
        if strMonth == "1" || strMonth == "jan" {
            return "Jan"
        }else if strMonth == "2" || strMonth == "feb" {
            return "Feb"
        }
        else if strMonth == "3" || strMonth == "mar" {
            return "Mar"
        }
        else if strMonth == "4" || strMonth == "apr" {
            return "Apr"
        }
        else if strMonth == "5" || strMonth == "may" {
            return "May"
        }
        else if strMonth == "6" || strMonth == "jun" {
            return "Jun"
        }
        else if strMonth == "7" || strMonth == "jul" {
            return "Jul"
        }
        else if strMonth == "8" || strMonth == "aug" {
            return "Aug"
        }
        else if strMonth == "9" || strMonth == "sep" {
            return "Sep"
        }
        else if strMonth == "10" || strMonth == "oct" {
            return "Oct"
        }
        else if strMonth == "11" || strMonth == "nov" {
            return "Nov"
        }
        else if strMonth == "12" || strMonth == "dec" {
            return "Dec"
        }else{
            return strMonth
        }
    }

    func GetDateStringFromDates(sDay:String,sMont:String,sYear:String,is_current:Bool,eDay:String,eMont:String,eYear:String) -> String {
        var strDates = ""
        let smonthname = Singleton.sharedSingleton.GetTextToNumericalMonth(strMonth: sMont)
        let emonthname = Singleton.sharedSingleton.GetTextToNumericalMonth(strMonth: eMont)
        if sDay == "" && sMont == "" && sYear == "" && eDay == "" && eMont == "" && eYear == "" && is_current {
            strDates = "N/A - Current"
            return strDates
        }
        else if sDay == "" && sMont == "" && sYear == "" && eDay == "" && eMont == "" && eYear == "" && !is_current {
            strDates = "N/A"
            return strDates
        }
        
        if is_current {
            if sDay == "" && sMont == "" && sYear == "" {
                strDates = "N/A"
            }
            else if sDay == "" && sMont != "" && sYear != "" {
                let arr = [smonthname,sYear]
                strDates = "\(arr.joined(separator: "/")) - Current"
            }
            else if sDay == "" && sMont == "" && sYear != "" {
                let arr = [sYear]
                strDates = "\(arr.joined(separator: "/")) - Current"
            }else{
                let arr = [sMont,sDay,sYear]
                strDates = "\(arr.joined(separator: "/")) - Current"
            }
        }else{
            if sDay == "" && sMont == "" && sYear == "" {
                strDates = "N/A - "
            }
            else if sDay == "" && sMont != "" && sYear != "" {
                let arr = [smonthname,sYear]
                strDates = "\(arr.joined(separator: "/")) - "
            }
            else if sDay == "" && sMont == "" && sYear != "" {
                let arr = [sYear]
                strDates = "\(arr.joined(separator: "/")) - "
            }
            else{
                let arr = [sMont,sDay,sYear]
                strDates = "\(arr.joined(separator: "/")) - "
            }
            
            if eDay == "" && eMont == "" && eYear == "" {
                strDates = strDates + "N/A"
            }
            else if eDay == "" && eMont != "" && eYear != "" {
                let arr = [emonthname,eYear]
                strDates = strDates + "\(arr.joined(separator: "/"))"
            }
            else if eDay == "" && eMont == "" && eYear != "" {
                let arr = [eYear]
                strDates = strDates + "\(arr.joined(separator: "/"))"
            }
            else{
                let arr = [eMont,eDay,eYear]
                strDates = strDates + "\(arr.joined(separator: "/"))"
            }
        }
        return strDates
    }
    
    func SetSingleDateStringFromDates(sDay:String,sMont:String,sYear:String) -> String {
        var strDates = ""
        let smonthname = Singleton.sharedSingleton.GetTextToNumericalMonth(strMonth: sMont)
        
        if sDay == "" && sMont == "" && sYear == "" {
            strDates = "N/A"
        }
        else if sDay == "" && sMont != "" && sYear != "" {
            let arr = [smonthname,sYear]
            strDates = "\(arr.joined(separator: "/"))"
        }
        else if sDay == "" && sMont == "" && sYear != "" {
            let arr = [sYear]
            strDates = "\(arr.joined(separator: "/"))"
        }else{
            let arr = [sMont,sDay,sYear]
            strDates = "\(arr.joined(separator: "/"))"
        }
        return strDates
    }
    
    //Phone Number masking
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func isPassword(str:String) -> Bool
    {
        let charset = CharacterSet(charactersIn: "aw")
        if str.rangeOfCharacter(from: charset) != nil {
            return true
        }else{
            return false
        }
    }
    
    func formattedHRD_NumberDisplay(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX ext.XXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    func getDouble(value:Any) -> Double {
        if let double_V = value as? Double {
            return double_V
        } else if let Int_V = value as? Int {
            return Double(Int_V)
        }else if let String_V = value as? String {
            return String_V.toDouble()
        }
        else{
            return 0.0
        }
    }
}

extension Array where Element: Equatable {
    
    mutating func removeElement(_ element: Element) -> Element? {
        if let index = index(of: element) {
            return remove(at: index)
        }
        return nil
    }
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
    
    var keepNumericsOnly: String {
        return self.components(separatedBy: CharacterSet(charactersIn: "0123456789+-:")).joined(separator: "")
    }
}
