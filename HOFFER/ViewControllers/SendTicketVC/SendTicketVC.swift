//
//  SendTicketVC.swift
//  HOFFER
//
//  Created by Admin on 31/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import ContactsUI

class SendTicketVC: UIViewController, UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var txtPersonName: SRCutomTextField!
    @IBOutlet weak var txtEmailView : SRCutomTextField!
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var viewEmail: UIView!
    
    var dicTicketReport = NSMutableDictionary()
    var isSend : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signatureView.delegate = self
        signatureView.layer.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        signatureView.layer.borderColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        signatureView.layer.borderWidth = 1.0
        
        if !isSend {
            btnSend.setTitle(" SAVE", for: .normal)
            viewEmail.isHidden = true
        }else{
            btnSend.setTitle(" SEND", for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClearPressed(_ sender: Any) {
        DispatchQueue.main.async {
          self.signatureView.clear()
        }
    }
    
    @IBAction func btnSendTicketPressed(_ sender: Any) {

        guard (self.txtPersonName.text?.count)! > 0 else{
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strNoPersonName)
            return
        }
        
        if isSend{
            let strEmail = self.txtEmailView.text!.trimmingCharacters(in: .whitespaces)
            guard strEmail.count > 0 else{
                Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strNoEmail)
                return
            }
            guard strEmail.isEmail else{
                Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strInvalidEmail)
                return
            }
        }
        
        if let signatureImage = self.signatureView.getSignature(scale: 4)
        {
            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
            DispatchQueue.main.async {
                self.signatureView.clear()
                if self.isSend{
                    self.view.squareLoading.start(delay: 0.0)
                    self.perform(#selector(self.sendTicket), with: signatureImage, afterDelay: 0.1)
                }else{
                    self.view.squareLoading.start(delay: 0.0)
                    self.perform(#selector(self.callSubmitTicketWebservice), with: signatureImage, afterDelay: 0.1)
                }
            }
        }
        else
        {
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Please create a Signature.") { (index, title) in
                
            }
        }
        
    }
    
    @objc func goBack(){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    
    //MARK:- API Call.
    @objc func callSubmitTicketWebservice(img : UIImage) {
        let strName = txtPersonName.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let strImagePath = img.saveToDocuments(filename: strName!) {
            let dicInput = NSMutableDictionary()
            dicInput.setValue("\(self.dicTicketReport.value(forKey: "date") ?? "-")", forKey: "date")
            dicInput.setValue("\(self.dicTicketReport.value(forKey: "trailer_number") ?? "-")", forKey: "trailer_number")
            dicInput.setValue("\(self.dicTicketReport.value(forKey: "product_name") ?? "-")", forKey: "product_name")
            dicInput.setValue("\(self.dicTicketReport.value(forKey: "delivery") ?? "-")", forKey: "delivery")
            dicInput.setValue("\(self.dicTicketReport.value(forKey: "units") ?? "-")", forKey: "units")
            dicInput.setValue("\(self.dicTicketReport.value(forKey: "accumulated_total") ?? "0")", forKey: "accumulated_total")
            let time = self.dicTicketReport.value(forKey: "time") == nil ? "-":"\(self.dicTicketReport.value(forKey: "time")!):00"
            dicInput.setValue(time, forKey: "time")
            dicInput.setValue("\(self.dicTicketReport.value(forKey: "delivery_number") ?? "-")", forKey: "delivery_number")
            dicInput.setValue(strName!, forKey: "person_name")
            dicInput.setValue("-1", forKey: "id")
            dicInput.setValue(strImagePath, forKey: "signature")
            
            // SAVE OFFLINE DATA
            //var isFound: Bool = false
            var arrTempArray = Singleton.sharedSingleton.arrSavedTicket
            arrTempArray.append(dicInput)
            UserDefaults.standard.set(arrTempArray, forKey: kUserDefault.savedTickets)
            UserDefaults.standard.synchronize()
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Ticket submit successfully.") { (index, title) in
                self.perform(#selector(self.goBack), with: nil, afterDelay: 0.6)
            }
        }else{
           print("Error in saved image")
        }
        self.view.squareLoading.stop(delay: 0.0)
    }
    
    @objc func sendTicket(img : UIImage) {
        autoreleasepool {
            if (Global.is_Reachablity().isNetwork)
            {
                //Apputility.startLoading(self.view);
                let request = NSMutableURLRequest();
                request.timeoutInterval = 120.0
                request.url = URL(string: webServiceURL + strApiSendEmail + "\(dicUserDetail.value(forKey: "user_id") ?? "0")");
                request.httpMethod = "POST";
                
                //request.setValue("bWVkaWNhbGJoOm1lZGljYWxAI2Jo", forHTTPHeaderField: "TOKEN");
                let boundary: String = "14737809831466499882746641449";
                let contentType: String = "multipart/form-data; boundary=\(boundary)";
                request.addValue(contentType, forHTTPHeaderField: "Content-Type");
                request.setValue(strApiKey, forHTTPHeaderField: "api_key")
                //-- Append data into posr url using following method
                var body = Data();
            
                
                let dicInput = OrderedDictionary()
                dicInput.setValue("\(self.dicTicketReport.value(forKey: "date") ?? "-")", forKey: "date")
                dicInput.setValue("\(self.dicTicketReport.value(forKey: "time") ?? "-")", forKey: "time")
                dicInput.setValue("\(self.dicTicketReport.value(forKey: "trailer_number") ?? "0")", forKey: "trailer_number")
                dicInput.setValue("\(self.dicTicketReport.value(forKey: "accumulated_total") ?? "0")", forKey: "accumulated_total")
                dicInput.setValue("\(self.dicTicketReport.value(forKey: "delivery") ?? "-")", forKey: "delivery")
                dicInput.setValue("\(self.dicTicketReport.value(forKey: "units") ?? "-")", forKey: "units")
                dicInput.setValue("\(self.dicTicketReport.value(forKey: "delivery_number") ?? "-")", forKey: "delivery_number")
                dicInput.setValue("\(self.dicTicketReport.value(forKey: "product_name") ?? "-")", forKey: "product_name")
    
                let jsonData = try? JSONSerialization.data(withJSONObject: dicInput, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                 
                 
                 body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!);
                 body.append("Content-Disposition: form-data; name=\"\("config_json")\"\r\n\r\n".data(using:     String.Encoding.utf8)!);
                 body.append("\(jsonString ?? "-")".data(using: String.Encoding.utf8)!);
                
                //-- For Sending text
                body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Disposition: form-data; name=\"\("person_name")\"\r\n\r\n".data(using:     String.Encoding.utf8)!);
                body.append("\(self.txtPersonName.text ?? "")".data(using: String.Encoding.utf8)!);
                
                
                body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Disposition: form-data; name=\"\("email")\"\r\n\r\n".data(using: String.Encoding.utf8)!);
                body.append("\(self.txtEmailView.text ?? "")".data(using: String.Encoding.utf8)!);
                

                let mimetype = "image/jpg"
				let imageData = img.pngData() as NSData?
                body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(".png")\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!);
                body.append(NSData(data: imageData! as Data) as Data)
                
                body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                
                
                print("URL; \(String(describing: request.url))")
                print("Json: \(String(describing: jsonString))")
                
                //-- Sending data into server through URL
                request.httpBody = body
                //-- Getting response form server
                let responseData: NSData? = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil) as NSData
                
                //-- JSON Parsing with response data
                //do {
                
                self.view.squareLoading.stop(delay: 0.0)
                if responseData == nil
                {
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Something went wrong.")
                    { (index, title) in
                        //self.perform(#selector(self.goBack), with: nil, afterDelay: 0.6)
                    }
                    return
                }
                
                let newStr = String(data: responseData! as Data, encoding: .utf8)
                print("\(String(describing: newStr))")
                if newStr?.lowercased().range(of:"0") != nil
                {
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Ticket submit successfully.") { (index, title) in
                        self.perform(#selector(self.goBack), with: nil, afterDelay: 0.6)
                    }
                }
                else
                {
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Something went wrong.")
                    { (index, title) in
                        self.perform(#selector(self.goBack), with: nil, afterDelay: 0.6)
                    }
                }
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: strNoInternet)
            }
        }
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
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtPersonName{
            self.txtPersonName.hideInfo()
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
    
}

extension SendTicketVC : YPSignatureDelegate {
    func didStart(_ view: YPDrawSignatureView) {

    }
    
    func didFinish(_ view: YPDrawSignatureView) {
        
    }
}

extension SendTicketVC : CNContactPickerDelegate {
    @IBAction func btnSelectContactPressed(_ sender: Any) {
        self.view.endEditing(true)
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        cnPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    //MARK:- CNContactPickerDelegate Method
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if let emailValue : CNLabeledValue = contact.emailAddresses.first
        {
            print(emailValue.value as String)
            self.txtEmailView.text = "\(emailValue.value)"
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
}

