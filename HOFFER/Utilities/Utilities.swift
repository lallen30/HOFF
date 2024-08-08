//
//  Utilities.swift
//  HOFFER
//
//  Created by JAM-E-214 on 24/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation
import SVProgressHUD
import Toast_Swift
extension UIView{
    func dropShadow(opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat,shadowColor:UIColor) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = shadowRadius
        layer.cornerRadius = cornerRadius
    }
 
}
class Utilities:NSObject{
    
    static let sharedInstance = Utilities()
    var notifecation = ""

    var cityList : [String] = []
    
    //MARK:- NUMBER FILER
    
    func numberFiler(string:String) -> Bool
    {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if string != numberFiltered
        {
            return false
        
        }
        //return false
        return true
    }
    
    func getPrecisedFormat(format:String, value:String) -> String{
        let floatValue = Float(value) ?? 0
        let stringValue = String(format: format, floatValue)
        return stringValue
    }
    

    
     func showAlertController(title:String,message:String,sourceViewController:UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            print("Okay Button Pressed...")
        }
        
        alertController.addAction(okButton)
        sourceViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert2(title:String,message:String,sourceViewController:UIViewController,completionHandler: @escaping (_ result:Bool) -> Void){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            completionHandler(true)
            print("Okay Button Pressed...")
        }
        
        alertController.addAction(okButton)
//        alertController.addAction(cancelButton)
        sourceViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert3(title:String,message:String,sourceViewController:UIViewController,completionHandler: @escaping (_ result:Bool) -> Void){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            completionHandler(true)
            print("Okay Button Pressed...")
        }
        
        let cancelButton = UIAlertAction(title: "No", style: .default)
        { (alertAction) in
            print("Cancel Button Pressed..")
        }
        
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        sourceViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showToast(source:UIViewController, message:String){
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .red
        style.cornerRadius = 18
        source.view.makeToast(message, duration: 2.0, position: .top, style: style)
    }
    
    func showError(message:String){
        SVProgressHUD.showDismissableError(with: message)

    }
    func showToastOk(source:UIViewController, message:String){
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        style.cornerRadius = 18
        source.view.makeToast(message, duration: 2.0, position: .top, style: style)
    }
    
    
    //MARK:Get ViewController
    
    func getVC(storyBoardName:String, vcId:String) -> UIViewController{
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: vcId)
        return vc
    }
    
    
    //MARK:Date Conversion
    
    func convertStringDate(date:String) -> Date?{
        let isoDate = date

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.date(from:isoDate)
        return convertedDate
    }
    
    func convertDate(date:String, format:String) -> Date?{
        let day = date
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US") // set locale to reliable US_POSIX
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.locale = Locale.current
        dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from:day)!
        return date
    }
    
    func getElapsedTimeStatus(timeInterval:Double) -> String{
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let string = formatter.localizedString(for: date, relativeTo: Date())
        return string
    }
    
    func getStringDateFromDate(date:Date, format:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    
    func getCurrentDate(format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
    
    func getFormattedDateFromString(dateString:String,toFormat:String,fromFormat:String,timeZone:String) -> String{
        
        if dateString == ""
        {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        dateFormatter.timeZone = timeZone != "" ? TimeZone(identifier: timeZone) : TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = fromFormat
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        guard let getData = dateFormatter.date(from: dateString) else { return ""}
        
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: getData)
        
    }
    
   
    
    
//MARK:- ATTRIBUTED TEXT
    
    func getAttributedText(string : NSString , strToReplace : NSString , setColor : UIColor) -> NSAttributedString
    {
        let attributedString1 = NSMutableAttributedString(string: "\(string)")
        attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: setColor, range: string.range(of: strToReplace as String))
        return attributedString1
    }
    
    func getAttributedFont(string : NSString , strToReplace : NSString , fontType : UIFont) -> NSAttributedString
    {
      let attributedString1 = NSMutableAttributedString(string: "\(string)")
        attributedString1.addAttribute(NSAttributedString.Key.font, value: fontType, range: string.range(of: strToReplace as String))
      return attributedString1
    }
    
    
    func getAttributedText2(stringToChange:String, unchangedString:String, font1:UIFont, font2:UIFont) -> NSMutableAttributedString{
        let attributedText = NSMutableAttributedString(string: stringToChange, attributes: [NSAttributedString.Key.font: font1])
        
        attributedText.append(NSAttributedString(string: unchangedString, attributes: [NSAttributedString.Key.font: font2, NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        return attributedText
    }
    

    static func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for validating email addresses
        let emailRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"

        // Create NSPredicate with format matching the email regex
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)

        // Test if the email matches the predicate
        return emailPredicate.evaluate(with: email)
    }
    private static let asciiCharacters = CharacterSet(charactersIn: (Unicode.Scalar(0)..<Unicode.Scalar(128)))
    private static let asciiAlphanumerics = CharacterSet.alphanumerics.intersection(asciiCharacters)
    private static let printableCharacters = CharacterSet(charactersIn: " !@#$%^&*()|<>,.[]{}:;'`~/?-_+=" ).union(asciiAlphanumerics)
    
    // Technically, this produces a Java literal string instead of a Swift
    // literal string, but I'm ok with that.
    public static func debugEscape(_ s: String) -> String {
        var sb = ""
        // Not a hard max, multichar representations can get a bit longer
        let MAX_LENGTH = 70

        sb.append("\"")
        var lineLength = 0

        s.unicodeScalars.forEach { cp in
            if ( lineLength > MAX_LENGTH ) {
                sb.append ( "\"\n+ \"" )
                lineLength = 0
            }
            if (printableCharacters.contains(cp)) {
                sb.append(Character(cp))
                lineLength += 1
            } else {
                let rep: String
                switch ( cp ) {
                    case "\t":
                        rep = "\\t"
                        break
                    case "\n":
                        rep = "\\n"
                        break
                    case "\\":
                        rep = "\\\\"
                        break
                    case "\r":
                        rep = "\\r"
                        break
                    case UnicodeScalar(12): // "\f", form feed
                        rep = "\\f"
                        break
                    case UnicodeScalar(8): // "\b", backspace
                        rep = "\\b"
                        break
                    case "\"":
                        rep = "\\\""
                        break
                    default:
                        let cpv = cp.value
                        if ( cpv >= 0 && cpv <= 0xff ) {
                            // use c-style byte escape, looks like "\\x3F"
                            rep = String(format: "\\x%02X" , cpv)
                        } else if ( cpv >= 0 && cpv <= 0xffff ) {
                            // should make a standard java 2-byte unicode char literal,
                            // i.e. format 0x23f like "\\u023F"
                            rep = String(format: "\\u%04X" , cpv)
                        } else {
                            rep = "#ERROR#"
                        }
                        break
                }
                sb.append(rep);
                lineLength += rep.count
            }
        }

        sb.append("\"")
        return sb
    }

}
