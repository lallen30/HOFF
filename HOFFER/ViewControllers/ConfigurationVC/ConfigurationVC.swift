//
//  ConfigurationVC.swift
//  HOFFER
//
//  Created by SiliconMac on 06/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI
enum configType : String {
    
    case reference = "reference"
    case temperature_unit = "temperature units"
    case default_temperature = "default temperature"
    case pressure_unit = "pressure units"
    case default_pressure = "default pressure"
    case delivery_unit = "delivery units"
    case total_decimal_places = "total decimal places"
    case fluid_type = "fluid type"
    case display = "display" //Display T/O (min)
    case compensation_method = "compensation method"
    case pump_delay = "pump delay (min)"
    case trailer_number = "trailer number"
    case serial_number = "serial number"
    case Meter_size = "meter size (inch)"
    case kfactor_method = "k-factor method"
    case average_kfactor = "average k-factor"
    
    //FOR THE FREQUENCY  WE DEFINE DEFFERENT BECASE SETTING CODE ARE DEFFERNT FOR ALL
    case Frequency_1 = "frequency[ 1]"
    case Frequency_2 = "frequency[ 2]"
    case Frequency_3 = "frequency[ 3]"
    case Frequency_4 = "frequency[ 4]"
    case Frequency_5 = "frequency[ 5]"
    
    //FOR THE KEFACTORE  WE DEFINE DEFFERENT BECASE SETTING CODE ARE DEFFERNT FOR ALL
    case kfactor_1 = "k-factor[ 1]"
    case kfactor_2 = "k-factor[ 2]"
    case kfactor_3 = "k-factor[ 3]"
    case kfactor_4 = "k-factor[ 4]"
    case kfactor_5 = "k-factor[ 5]"
    
    case none = "-"
    case undefine
    
}

class ConfigurationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CNContactPickerDelegate,MFMailComposeViewControllerDelegate  {
    
    //MARK:- EMAIL POPOVERVIEW
    @IBOutlet var popupEmailView: UIView!
    @IBOutlet weak var btnSaveEmail: UIButton!
    @IBOutlet weak var btnCloseEmail: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEditConfigTitle: UILabel!
    
    //MARK:- IBOutlets & Variables Declaration
    @IBOutlet weak var tblConfiguration: UITableView!
    @IBOutlet weak var btnBluetoothConnection: UIButton!
    @IBOutlet var popupView: UIView!
    
    @IBOutlet var popupPinCodeView: UIView!
    @IBOutlet weak var txtPinCode: UITextField!
    
    var arrResult : [[String:Any]] = []
    var arrSetValues : [configType] = [.temperature_unit,.average_kfactor,.compensation_method,.default_pressure,.default_temperature,.delivery_unit,.pump_delay,.Frequency_1,.Frequency_2,.Frequency_3,.Frequency_4,.Frequency_5,.fluid_type,.kfactor_1,.kfactor_2,.kfactor_3,.kfactor_4,.kfactor_5,.Meter_size,.pressure_unit,.total_decimal_places,.trailer_number,.serial_number,.kfactor_method,.reference]
    
    var strOutPut:String = ""
    var typeSetting: configType = .none
    var isDevCall:Bool = false
    
    var isVerifyUser:Bool = false
    var textField: UITextField?
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPinCode.delegate = self
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 35, height: self.txtEmail.frame.size.height))
        txtEmail.rightView = paddingView
		txtEmail.rightViewMode = UITextField.ViewMode.always
        
        popupView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        popupEmailView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        popupPinCodeView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        //COMAND FOR CONFIGURATION
        self.load_CONFIGURATION_Data()
    }
    
    func load_CONFIGURATION_Data(){
        self.view.squareLoading.start(delay: 0.0)
        ICEManagerVC.shared.send_DA_Command { (strResult) in
            self.view.squareLoading.stop(delay: 0.0)
            if strResult != ""
            {
                print("Configuration Came Final" + "\(strResult)")
                self.strOutPut = strResult
                self.addTicketValuesToArray()
                //self.perform(#selector(self.goSetConfiguration), with: nil, afterDelay: 10.0)
            }else{
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
            }
        }
    }
    
    func addTicketValuesToArray() {
        self.arrResult = self.strOutPut.ConvertArduinoDACommandToArray()
        if self.arrResult.count > 0 {
            self.tblConfiguration.reloadData()
        }
        else
        {
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Something went wrong, Please try again or reset you ICE device.") { (index, title) in
                self.perform(#selector(self.goBack), with: nil, afterDelay: 0.6)
            }
        }
        
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goSetConfiguration(){        
        ICEManagerVC.shared.send_SetConfigure_Command("DFP=100.0") { (strResult) in
            if strResult != "" {
                print("Configuration Came Final" + "\(strResult)")
                self.view.squareLoading.stop(delay: 0.0)
            }else{
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UITableView Delegates and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath) as! ConfigurationCell
        cell.lblParameter.text = "\(self.arrResult[indexPath.row]["key"] as? String ?? "-")"
        cell.lblValue.text = "\(self.arrResult[indexPath.row]["value"] as? String ?? "-")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MAKE HERE TITLE TO CLARIFY THE EDIT STATEMENT
        let strTitleKey = self.arrResult[indexPath.row]["key"] as? String ?? "-"
        if let type = configType(rawValue: strTitleKey.lowercased().trimmingCharacters(in: .whitespaces)) {
            self.typeSetting = type
        }else {
            if strTitleKey.lowercased().range(of:"pump delay") != nil {
                self.typeSetting = .pump_delay
            }else if strTitleKey.lowercased().range(of:"display") != nil {
                self.typeSetting = .display
            }else if strTitleKey.lowercased().range(of:"meter size ") != nil {
                self.typeSetting = .Meter_size
            }
            else if strTitleKey.lowercased().range(of:"reference") != nil {
                self.typeSetting = .reference
            }
            else{
                self.typeSetting = .undefine
            }
        }
        if self.arrSetValues.contains(self.typeSetting) {
            //guard isVerifyUser else {
                //self.openAlertView()
                //return
            //}
            
            IPAlertTextField.initialization().showAlert(strUrl: strTitleKey, typeSettings: self.typeSetting, completion: {
                print("Show")
                self.load_CONFIGURATION_Data()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - Show Password alert box
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Enter password here";
            self.textField?.isSecureTextEntry = true
        }
    }
    
    func openAlertView() {
		let alert = UIAlertController(title:"Password", message:"Please enter your login password", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Cancel button")
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            print("User click Ok button")
            if let strPassword = self.textField?.text {
                if strPassword.count > 0 {
                    self.view.squareLoading.start(delay: 0.0)
                    Singleton.sharedSingleton.call_verifyUsers(strPassword, successBlock: {
                        self.view.squareLoading.stop(delay: 0.0)
                        print("setDevicesName Successfully")
                        self.isVerifyUser = true
                    }, failureBlock: {
                        self.view.squareLoading.stop(delay: 0.0)
                         print("setDevicesName Failed")
                    })
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - API CALLER METHODS
    func Call_sendEmail(strEmail:String) -> Void {
        let dicInput = NSMutableDictionary()
        dicInput.setValue(strEmail, forKey: "email")
        let tmpDic = OrderedDictionary()
        for dic in self.arrResult
        {
            tmpDic.setValue("\(dic["value"] ?? "")", forKey: "\(dic["key"] ?? "")")
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: tmpDic, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        dicInput.setValue("\(jsonString!)", forKey: "config_json")
        dicInput.setValue("0", forKey: "array_json")
        
        let _ = AkWebServiceCall().CallApiWithPath(path: strApiSendEmail + "\(dicUserDetail.value(forKey: "user_id") ?? "0")", input: dicInput, showLoader: true, view: self.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            
            if isSuccess && dicResponse.value(forKey: "code") as! String == "0"
            {
                //Ticket deleted
                Singleton().showAlertWithSingleButton(strMessage: strEmailSentSuccess)
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
            }
            
        }) { (dicResponse, isSuccess) in
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
        }
    }
    
    func Call_sendEmailDeveloper(strEmail:String) -> Void {
        if self.strOutPut == "" {
            Singleton().showAlertWithSingleButton(strMessage:"Something Went Wrong.")
            return
        }
        
        let dicInput = NSMutableDictionary()
        dicInput.setValue("\(self.strOutPut.toBase64()!)", forKey: "array_json")
        print("PARAMS:\(dicInput)")
        let _ = AkWebServiceCall().CallApiWithPath(path: "users/sendmailadmin", input: dicInput, showLoader: true, view: self.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            
            if isSuccess && dicResponse.value(forKey: "code") as! String == "0"
            {
                //Ticket deleted
                Singleton().showAlertWithSingleButton(strMessage: strEmailSentSuccess)
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
            }
            
        }) { (dicResponse, isSuccess) in
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func btnChangePinPressed(_ sender: UIButton) {
        
        popupPinCodeView.center = view.center
        popupPinCodeView.alpha = 1
        popupPinCodeView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        self.view.addSubview(popupPinCodeView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            //go back to original form
            self.popupPinCodeView.transform = .identity
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func btnDisconnectPressed(_ sender: Any) {
        BleManager.shared.disconnectConnectedDivice()
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func btnBluetoothConnectionPressed(_ sender: UIButton) {
        
    }
	
	
	@IBAction func btnBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
    
    @IBAction func btnSendPressed(_ sender: UIButton) {
        isDevCall = false
        popupEmailView.center = view.center
        popupEmailView.alpha = 1
        popupEmailView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        self.view.addSubview(popupEmailView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            //go back to original form
            self.popupEmailView.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnSendDeveloperPressed(_ sender: UIButton) {
        isDevCall = true
        Call_sendEmailDeveloper(strEmail: "")
    }
    
    //MAIL CONTROLLER DEFAULT
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            //mail.setToRecipients([])
            mail.setMessageBody("\"\(self.strOutPut)\"", isHTML: false)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    @IBAction func btnHideMeTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupView.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.popupView.alpha = 0
        }) { (success) in
            self.popupView.removeFromSuperview()
        }
        
    }
    
    @IBAction func btnSelectContactPressed(_ sender: Any) {
        self.view.endEditing(true)
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        cnPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnConfirmPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let strPin = self.txtPinCode.text!.trimmingCharacters(in: .whitespaces)
        
        guard strPin.count > 0 else {
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strNoPin)
            return
        }
        
        guard strPin.count == 4 else {
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strPinValidation)
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set("\(strPin)", forKey: "mainPinCode")
        defaults.synchronize()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupPinCodeView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.popupPinCodeView.alpha = 0
        }) { (success) in
            self.txtPinCode.text = ""
            self.popupPinCodeView.removeFromSuperview()
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strPinChangeSuccess)
        }
        
    }
    
    @IBAction func btnCloseChangePinPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupPinCodeView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.txtPinCode.text = ""
            self.popupPinCodeView.removeFromSuperview()
        }
    }
    
    //MARK:- CNContactPickerDelegate Method
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        if let emailValue : CNLabeledValue = contact.emailAddresses.first
        {
            print(emailValue.value as String)
            self.txtEmail.text = "\(emailValue.value)"
        }
        
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    
    // MARK: - UITextField Delegate METHODS
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPinCode {
            if let text = textField.text,
                let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,with: string)
                if updatedText.count > 4 {
                    return false
                }
            }
        }        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        let viewSize: Double = Double(self.view.frame.size.height);
        //        if viewSize < 1000 {
        //                UIView.animate(withDuration: 0.2, animations: {() -> Void in
        //                    var frame: CGRect = self.view.frame;
        //                    frame.origin.y -= 110;
        //                    self.view.frame = frame;
        //                });
        //        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //        let viewSize: Double = Double(self.view.frame.size.height);
        //        if viewSize < 1000 {
        //                UIView.animate(withDuration: 0.2, animations: {() -> Void in
        //                    var frame: CGRect = self.view.frame;
        //                    if(frame.origin.y < 0){
        //                        frame.origin.y += 110;
        //                    }else{
        //                        frame.origin.y = 0;
        //                    }
        //                    self.view.frame = frame;
        //                });
        //        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    
    
    
    //MARK: UIBUTTON ACTION FOR THE POPUP SCREEN
    @IBAction func btnSendEmailclick(_ sender: UIButton) {
        
        let strEmail = self.txtEmail.text!.trimmingCharacters(in: .whitespaces)
        
        guard strEmail.count > 0 else{
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strNoEmail)
            return
        }
        guard strEmail.isEmail else{
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strInvalidEmail)
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupEmailView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.popupEmailView.alpha = 0
        }) { (success) in
            self.popupEmailView.removeFromSuperview()
            self.Call_sendEmail(strEmail: strEmail)
        }
    }
    
    func SentToDeveloperEmailclick(_ sender: UIButton) {
        let strEmail = self.txtEmail.text!.trimmingCharacters(in: .whitespaces)
        
        guard strEmail.count > 0 else{
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strNoEmail)
            return
        }
        guard strEmail.isEmail else{
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strInvalidEmail)
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupEmailView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.popupEmailView.alpha = 0
        }) { (success) in
            self.popupEmailView.removeFromSuperview()
            if self.isDevCall {
              self.Call_sendEmailDeveloper(strEmail:strEmail)
            }else{
              self.Call_sendEmail(strEmail: strEmail)
            }
        }
    }
    
    @IBAction func btnSaveCloseclick(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupEmailView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.popupEmailView.removeFromSuperview()
        }
    }
}




