//
//  ForgotPasswordVC.swift
//  HOFFER
//
//  Created by Admin on 31/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController, UITextFieldDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet var txtEmail: SRCutomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- IB Actions
    
    @IBAction func btnSendEmailPressed(_ sender: Any) {
        
        let strEmail = self.txtEmail.text!.trimmingCharacters(in: .whitespaces)
        
        guard strEmail.count > 0 else {
            self.txtEmail.showInfo(strNoEmail)
            return
        }
        guard strEmail.isEmail else {
            self.txtEmail.showInfo(strInvalidEmail)
            return
        }
        
        let dicInput = NSMutableDictionary()
        dicInput.setValue(self.txtEmail.text!, forKey: "email");
        print(dicInput)
        
        let _ = AkWebServiceCall().CallApiWithPath(path: "users/forgot_password", input: dicInput, showLoader: true, view: self.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            
            print(dicResponse)
            
            if isSuccess
            {
                if dicResponse.value(forKey: "code") as! String == "0"
                {
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: dicResponse["message"] as! String, completion: { (index, title) in
                        self.navigationController?.popViewController(animated: true)
                    })
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
            
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)

        }
    }
    
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- TextField Delegate Methods.
    
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
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtEmail{
            self.txtEmail.hideInfo()
        }
        
//        let viewSize: Double = Double(self.view.frame.size.height);
//        if viewSize < 1000
//        {
//            UIView.animate(withDuration: 0.2, animations:
//                {() -> Void in
//                    var frame: CGRect = self.view.frame;
//                    frame.origin.y -= 80;
//                    self.view.frame = frame;
//            });
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let viewSize: Double = Double(self.view.frame.size.height);
//        if viewSize < 1000
//        {
//            UIView.animate(withDuration: 0.2, animations:
//                {() -> Void in
//                    var frame: CGRect = self.view.frame;
//                    if(frame.origin.y < 0)
//                    {
//                        frame.origin.y += 80;
//                    }
//                    else
//                    {
//                        frame.origin.y = 0;
//                    }
//                    self.view.frame = frame;
//            });
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
