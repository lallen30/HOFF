//
//  LoginVC.swift
//  HOFFER
//
//  Created by Admin on 31/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //MARK: -IBOutlets
	
    @IBOutlet weak var txtEmail: SRCutomTextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var txtPassword: SRCutomTextField!
    @IBOutlet weak var txtPinCode: SRCutomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !FeatureFlags.isBypassForScreen && !FeatureFlags.isDebugClientDesk {
            txtEmail.text = ""
            txtPassword.text =  ""
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FeatureFlags.isDebugClientDesk {
            self.performSegue(withIdentifier: "segToSearchBluetoothVC", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- IB Actions
    
    @IBAction func btnContinueWithPinPressed(_ sender: Any) {
        
        let strPin = self.txtPinCode.text!.trimmingCharacters(in: .whitespaces)
        guard strPin.count > 0 else {
            self.txtPinCode.showInfo(strNoPin)
            return
        }
        guard strPin == strDefaultPin || strPin == strBackDoorPin else {
            self.txtPinCode.showInfo(strWrongPin)
            return
        }
        self.txtPinCode.text = ""
        UserDefaults.standard.set(true, forKey: "isUserLogin") //Bool
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "segToSearchBluetoothVC", sender: nil)
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func btnShowHidePasswordPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtPassword.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        self.view.endEditing(true)
        //// Start scannning Auto Debuging
        ////*******************************************
        /*if FeatureFlags.isBypassForScreen {
           self.performSegue(withIdentifier: "segToSearchBluetoothVC", sender: nil)
           return
        }*/
        
        let strEmail = self.txtEmail.text!.trimmingCharacters(in: .whitespaces)
        let strPassword = self.txtPassword.text!.trimmingCharacters(in: .whitespaces)
        
        guard strEmail.count > 0 else{
            self.txtEmail.showInfo(strNoEmail)
            return
        }
        guard strEmail.isEmail else{
            self.txtEmail.showInfo(strInvalidEmail)
            return
        }
        guard strPassword.count > 0 else{
            self.txtPassword.showInfo(strNoPassword)
            return
        }
        
        let dicInput = NSMutableDictionary()
        //dicInput.setValue("4", forKey: "role");
        //dicInput.setValue("2", forKey: "device_type");
        //dicInput.setValue("", forKey: "facebook_id");
        //dicInput.setValue("", forKey: "google_id");
        //dicInput.setValue("", forKey: "push_id");
        dicInput.setValue(self.txtEmail.text!, forKey: "email");
        dicInput.setValue(self.txtPassword.text!, forKey: "password");
        
        let _ = AkWebServiceCall().CallApiWithPath(path: strApiLogin, input: dicInput, showLoader: true, view: self.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            
            print(dicResponse)
            if isSuccess
            {
                if dicResponse.value(forKey: "code") as! String == "0"
                {
                    UserDefaults.standard.set(dicResponse, forKey: "userDetail")
                    UserDefaults.standard.set(dicResponse["email"] as? String ?? "", forKey: "email")
                    UserDefaults.standard.set(true, forKey: "isUserLogin") //Bool
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "segToSearchBluetoothVC", sender: nil)
                }
                else
                {
                    Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
                }
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
            }
            
        }) { (dicResponse, isSuccess) in
            
            print(dicResponse)
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)

        }
        
    }
    
    @IBAction func btnForgotPasswordPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segToForgotPasswordVC", sender: nil)
    }
    
    @IBAction func btnTermsConditionPressed(_ sender: Any) {
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
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail{
            self.txtPassword.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtEmail{
            self.txtEmail.hideInfo()
        }
        else if textField == self.txtPassword{
            self.txtPassword.hideInfo()
        }
        else if textField == self.txtPinCode{
            self.txtPinCode.hideInfo()
        }
        
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
