//
//  DeliveryTicketVC.swift
//  HOFFER
//
//  Created by SiliconMac on 25/07/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import ContactsUI
import SDWebImage

class DeliveryTicketVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CNContactPickerDelegate {
    
    
    //MARK:- IBOutlets & Variables Declaration
    @IBOutlet var popupEmailView: UIView!
    @IBOutlet weak var btnSaveEmail: UIButton!
    @IBOutlet weak var btnCloseEmail: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var tblDeliveryTicket: UITableView!
    @IBOutlet weak var btnSaveDeleteTicket: UIButton!
    @IBOutlet weak var btnBluetoothConnection: UIButton!
    
    
    var dicTicket = NSMutableDictionary()
    var arrDeliveryTicketData = NSMutableArray()
    var isFromSavedTicket = false
    var strOutPut = "" //"RDT\nRDT\nProcessMsg::command == RDT\n\rMETER DELIVERY TICKET\n\rTRAILER NUMBER: \n\r1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:       62\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:48\n\rDELIVERY NUMBER:   25\n\rACCUMULATED TOTAL:\n\r     2090\n\r"
    
    var arrDeliveryParametersIcons : NSMutableArray = ["trailerNumberIcon",
                                                        "productNameIcon",
                                                        "DeliveryIcon",
                                                        "unitIcon",
                                                        "dateIcon",
                                                        "timeIcon",
                                                        "DeliveryIcon",
                                                        "accumulated"
    ]
    
    var arrDeliveryParameters : NSMutableArray = ["TRAILER NUMBER:",
                                                   "PRODUCT NAME:",
                                                   "DELIVERY:",
                                                   "UNITS:",
                                                   "DATE:",
                                                   "TIME:",
                                                   "DELIVERY NUMBER:",
                                                   "ACCUMULATED TOTAL:"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDeliveryTicket.register(UINib(nibName: "DeliveryTicketSignatureCell", bundle: nil), forCellReuseIdentifier: "DeliveryTicketSignatureCell")
        
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 35, height: self.txtEmail.frame.size.height))
        txtEmail.rightView = paddingView
		txtEmail.rightViewMode = UITextField.ViewMode.always
        
        popupEmailView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        if isFromSavedTicket {
            self.addTicketValuesToArray()
        } else {
            self.view.squareLoading.start(delay: 0.0)
            ICEManagerVC.shared.sendRDTCommand({ (strResult) in
                
                self.view.squareLoading.stop(delay: 0.0)
                if strResult != ""
                {
                    print("Result Came Final" + "\(strResult)")
                    self.strOutPut = strResult
                    self.addTicketValuesToArray()
                }
                else
                {
                    Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
                }
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getDocumentsPath(strName:String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(strName)
    }
    
	
	
	@IBAction func btnBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
    //MARK:- 
    //MARK:- CALL API METHODS
    func sendTicket(){
        guard Singleton.sharedSingleton.isConnectivityChecked() else {
            Singleton().showAlertWithSingleButton(strMessage: strNoInternet)
            return
        }
        
        self.view.squareLoading.start(delay: 0.0)
        let dicInput = OrderedDictionary()
        dicInput.setValue("\(self.txtEmail.text!)", forKey: "email")
        // ADD CODE FOR THE REMOVE UNNECESSORY KEY
        let aDictTemp : NSMutableDictionary = NSMutableDictionary()
        for element in self.dicTicket {
            if let strKeys = element.key as? String, strKeys != "signature" {
                aDictTemp.setValue(element.value, forKey: element.key as! String)
            }
        }

        dicInput.setValue("0", forKey: "array_json")
        
        if isFromSavedTicket {
            if let intId = self.dicTicket["id"] as? Int, intId != -1 {
                dicInput.setValue(intId.description, forKey: "ticket_id")
            }else if let strId = self.dicTicket["id"] as? String, strId != "-1" {
                dicInput.setValue(strId, forKey: "ticket_id")
            }
        }
        
        let _ = AkWebServiceCall().CallApiWithPath(path: strApiSendEmail + "\(dicUserDetail.value(forKey: "user_id") ?? "0")", input: dicInput, showLoader: true, view: self.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            print(dicResponse)
            self.view.squareLoading.stop(delay: 0.0)
            if isSuccess && dicResponse.value(forKey: "code") as! String == "0"
            {
                //Ticket Sent
                self.txtEmail.text = ""
                Singleton().showAlertWithSingleButton(strMessage: strEmailSentSuccess)
                //self.btnSaveDeleteTicket.isEnabled = false
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
            }
            
        }) { (dicResponse, isSuccess) in
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
        }
        
    }
    
    @objc func call_sendTicketWith(img : UIImage,strEmail:String) {
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
                dicInput.setValue("\(self.dicTicket.value(forKey: "date") ?? "-")", forKey: "date")
                dicInput.setValue("\(self.dicTicket.value(forKey: "time") ?? "-")", forKey: "time")
                dicInput.setValue("\(self.dicTicket.value(forKey: "trailer_number") ?? "-")", forKey: "trailer_number")
                dicInput.setValue("\(self.dicTicket.value(forKey: "accumulated_total") ?? "-")", forKey: "accumulated_total")
                dicInput.setValue("\(self.dicTicket.value(forKey: "delivery") ?? "-")", forKey: "delivery")
                dicInput.setValue("\(self.dicTicket.value(forKey: "units") ?? "-")", forKey: "units")
                dicInput.setValue("\(self.dicTicket.value(forKey: "delivery_number") ?? "-")", forKey: "delivery_number")
                dicInput.setValue("\(self.dicTicket.value(forKey: "product_name") ?? "-")", forKey: "product_name")
                
                let jsonData = try? JSONSerialization.data(withJSONObject: dicInput, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                
                
                body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Disposition: form-data; name=\"\("config_json")\"\r\n\r\n".data(using:     String.Encoding.utf8)!);
                body.append("\(jsonString ?? "-")".data(using: String.Encoding.utf8)!);
                
                //-- For Sending text
                body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Disposition: form-data; name=\"\("person_name")\"\r\n\r\n".data(using:     String.Encoding.utf8)!);
                body.append("\(self.dicTicket.value(forKey: "person_name") ?? "-")".data(using: String.Encoding.utf8)!);
                
                
                body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Disposition: form-data; name=\"\("email")\"\r\n\r\n".data(using: String.Encoding.utf8)!);
                body.append("\(strEmail)".data(using: String.Encoding.utf8)!);
                
                
                let mimetype = "image/jpg"
				let imageData = img.pngData() as NSData?
                body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(".png")\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!);
                body.append(NSData(data: imageData! as Data) as Data)
                
                body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                
                print("URL; \(request.url)")
                print("Json: \(jsonString)")
                
                
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
                print("\(newStr)")
                
                if newStr?.lowercased().range(of:"0") != nil
                {
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Ticket submit successfully.") { (index, title) in
                         self.DeleteLocalRecoreds(isSilent: true)
                    }
                }
                else
                {
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Something went wrong.")
                    { (index, title) in
                        
                    }
                }
            }
            else
            {
                self.view.squareLoading.stop(delay: 0.0)
                Singleton().showAlertWithSingleButton(strMessage: strNoInternet)
            }
        }
    }
    
    // SAVE OFFLINE TICKET
    // USING USERDEFAULS + ARRAY LIST
    
    func saveTicket() {
        
        let dicInput = NSMutableDictionary()
        dicInput.setValue("\(self.dicTicket.value(forKey: "trailer_number") ?? "-")", forKey: "trailer_number")
        dicInput.setValue("\(self.dicTicket.value(forKey: "product_name") ?? "-")", forKey: "product_name")
        dicInput.setValue("\(self.dicTicket.value(forKey: "delivery") ?? "-")", forKey: "delivery")
        dicInput.setValue("\(self.dicTicket.value(forKey: "units") ?? "-")", forKey: "units")
        dicInput.setValue("\(self.dicTicket.value(forKey: "date") ?? "-")", forKey: "date")
        dicInput.setValue("\(self.dicTicket.value(forKey: "time") ?? "-")", forKey: "time")
        dicInput.setValue("\(self.dicTicket.value(forKey: "delivery_number") ?? "-")", forKey: "delivery_number")
        dicInput.setValue("\(self.dicTicket.value(forKey: "accumulated_total") ?? "-")", forKey: "accumulated_total")
        
        let _ = AkWebServiceCall().CallApiWithPath(path: strApiSaveTicket + "\(dicUserDetail.value(forKey: "user_id") ?? "0")", input: dicInput, showLoader: true, view: self.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            
            print(dicResponse)
            if isSuccess && dicResponse.value(forKey: "code") as! String == "0"
            {
                //Ticket deleted
                Singleton().showAlertWithSingleButton(strMessage: strTicketSavedSuccess)
                self.btnSaveDeleteTicket.isEnabled = false
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
            }
            
        }) { (dicResponse, isSuccess) in
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
        }
    }
    
    // MAIL DELETE FUNCTION FOR THE CHECKING TICKET IS FORM API OR LOCAL
    func deleteTicket() {
        if let intId = self.dicTicket["id"] as? Int, intId != -1 { // FROM API
            call_Delete_Ticket(ticketID: intId.description)
        }else if let strId = self.dicTicket["id"] as? String, strId != "-1" { // FROM API
            call_Delete_Ticket(ticketID: strId)
        }else{
            DeleteLocalRecoreds() //LOCAL ONLY
        }
    }
    
    //FUNC DELETE
    func call_Delete_Ticket(ticketID:String){
        let dicInput = NSMutableDictionary()
        let _ = AkWebServiceCall().CallApiWithPath(path: strApiDeleteTicket + "\(dicUserDetail.value(forKey: "user_id") ?? "0")" + "/" + "\(ticketID)", input: dicInput, showLoader: true, view: self.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in
            print(dicResponse)
            if isSuccess && dicResponse.value(forKey: "code") as! String == "0" {
                //Ticket deleted
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: dicResponse["message"] as! String, completion: { (index, str) in
                    Global().delay(delay: 1.5, closure: {
                        self.navigationController?.popViewController(animated: true)
                    })
                })
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
            }
            
        }) { (dicResponse, isSuccess) in
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
        }
    }

    func DeleteLocalRecoreds(isSilent:Bool = false){
        if let strImage = self.dicTicket["signature"] as? String {
            var foundIndex = -1
            for (index, element) in Singleton.sharedSingleton.arrSavedTicket.enumerated() {
                if let image = element["signature"] as? String, image == strImage {
                    foundIndex = index
                    Singleton.sharedSingleton.deleteLocalRecoard(strName: image)
                    break
                }
            }
            //INDEX
            if foundIndex != -1 {
              var arrRecords = Singleton.sharedSingleton.arrSavedTicket
              arrRecords.remove(at: foundIndex)
              UserDefaults.standard.set(arrRecords, forKey: kUserDefault.savedTickets)
              UserDefaults.standard.synchronize()
                if isSilent {
                    Global().delay(delay:1.0, closure: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage:"Ticket delete successful.", completion: { (index, str) in
                        Global().delay(delay: 1.0, closure: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                }
              
            }
        }
        
    }
    
    //FUNC FOR SETUP DATA IN TO THE ARARY
    
    func addTicketValuesToArray() {
        self.arrDeliveryTicketData.removeAllObjects()
        if !isFromSavedTicket
        {
            self.dicTicket = self.strOutPut.ConvertArduinoRDTCommandToDicationary()
            self.btnSaveDeleteTicket.setTitle(" SAVE", for: .normal)
            self.btnSaveDeleteTicket.setImage(#imageLiteral(resourceName: "Save_Icon"), for: .normal)
        }
        else
        {
            self.btnSaveDeleteTicket.setTitle(" DELETE", for: .normal)
            self.btnSaveDeleteTicket.setImage(#imageLiteral(resourceName: "Delete_Icon"), for: .normal)
            // Need to add signature
            arrDeliveryParametersIcons = ["trailerNumberIcon",
                                           "productNameIcon",
                                           "DeliveryIcon",
                                           "unitIcon",
                                           "dateIcon",
                                           "timeIcon",
                                           "DeliveryIcon",
                                           "accumulated",
                                           "DeliveryIcon"
            ]
            // Need to add signature
            arrDeliveryParameters = ["TRAILER NUMBER:",
                                      "PRODUCT NAME:",
                                      "DELIVERY:",
                                      "UNITS:",
                                      "DATE:",
                                      "TIME:",
                                      "DELIVERY NUMBER:",
                                      "ACCUMULATED TOTAL:",
                                      "SIGNATURE:"]
        }
        
        self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "trailer_number") ?? "-")")
        self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "product_name") ?? "-")")
        self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "delivery") ?? "-")")
        self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "units") ?? "-")")
        self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "date") ?? "-")")
        self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "time") ?? "-")")
        self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "delivery_number") ?? "-")")
        self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "accumulated_total") ?? "-")")
        if isFromSavedTicket {
            self.arrDeliveryTicketData.add("\(self.dicTicket.value(forKey: "signature") ?? "")")
        }
        self.tblDeliveryTicket.reloadData()
    }
    
    //MARK:- 
    //MARK:- UITableView Delegates and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDeliveryTicketData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let strKeys = self.arrDeliveryParameters[indexPath.row] as? String, strKeys == "SIGNATURE:" {
            print("For signature")
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTicketSignatureCell", for: indexPath) as! DeliveryTicketSignatureCell
            cell.imgIcon.image = UIImage.init(named: "\(arrDeliveryParametersIcons[indexPath.row])")
            cell.lblParameter.text = "\(self.arrDeliveryParameters[indexPath.row])"
            cell.imgSignature.contentMode = .scaleToFill
            if let intId = self.dicTicket["id"] as? Int, intId != -1 {
//				cell.imgSignature.sd_setIndicatorStyle(UIActivityIndicatorView.Style.white)
				cell.imgSignature.sd_imageIndicator = SDWebImageActivityIndicator.white
                cell.imgSignature.sd_setImage(with: URL(string:"\(strMediaURL)\(self.arrDeliveryTicketData[indexPath.row])" ), completed: nil)
            }else if let strId = self.dicTicket["id"] as? String, strId != "-1" {
//				cell.imgSignature.sd_setIndicatorStyle(UIActivityIndicatorView.Style.white)
				cell.imgSignature.sd_imageIndicator = SDWebImageActivityIndicator.white
                cell.imgSignature.sd_setImage(with: URL(string:"\(strMediaURL)\(self.arrDeliveryTicketData[indexPath.row])" ), completed: nil)
                cell.imgSignature.contentMode = .scaleToFill
            }else{
                cell.imgSignature.image = UIImage(contentsOfFile: getDocumentsPath(strName: self.arrDeliveryTicketData[indexPath.row] as! String).path)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTicketCell", for: indexPath) as! DeliveryTicketCell
            cell.imgIcon.image = UIImage.init(named: "\(arrDeliveryParametersIcons[indexPath.row])")
            cell.lblParameter.text = "\(self.arrDeliveryParameters[indexPath.row])"
            cell.lblValue.text = "\(self.arrDeliveryTicketData[indexPath.row])"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension // (tableView.frame.height)/CGFloat(arrDeliveryTicketData.count)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // MARK: - 
    // MARK: - IBActions
    @IBAction func btnSaveTicketPressed(_ sender: UIButton) {
        if (sender.currentTitle?.contains("SAVE"))!{
            self.performSegue(withIdentifier: "segToSignatureVC", sender: nil)
        }
        else{
            AJAlertController.initialization().showAlert(aStrMessage: strAskForDelete, aCancelBtnTitle: "NO", aOtherBtnTitle: "YES") { (Int, strButton) in
                
                if strButton == "YES"
                {
                    self.deleteTicket()
                }
            }
        }
    }
    
    @IBAction func btnSendTicketPressed(_ sender: UIButton) {
        if isFromSavedTicket{  // FOR SAVED TICKETS + OFFLINE
            popupEmailView.center = view.center
            popupEmailView.alpha = 1
            popupEmailView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            self.view.addSubview(popupEmailView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                //go back to original form
                self.popupEmailView.transform = .identity
                self.view.layoutIfNeeded()
            })
        }else{ // FOR NOT SAVED
            self.performSegue(withIdentifier: "segToSignatureVC", sender: true)
        }
    }
    
    @IBAction func btnSendEmailclick(_ sender: UIButton) {
        self.view.endEditing(true)
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
            if let strImage = self.dicTicket["signature"] as? String {
                if let img = UIImage(contentsOfFile: self.getDocumentsPath(strName: strImage).path) {
                    self.view.squareLoading.start(delay: 0.0)
                    Global().delay(delay: 0.5, closure: {
                       self.call_sendTicketWith(img: img, strEmail: strEmail)
                    })
                }else{
                    self.sendTicket()
                }
            }
        }
    }
    
    @IBAction func btnSaveCloseclick(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupEmailView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.popupEmailView.removeFromSuperview()
            self.txtEmail.text = ""
        }
    }
    
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
    
    
    
    
    // MARK: - Tmp Methods
    func convertResponseOfMeterDeliveryTicketToArray(strResponse : String) {
        
        var strNewToOutput = strResponse
        print(strNewToOutput)
        let arr = strNewToOutput.components(separatedBy: "METER DELIVERY TICKET")
        if arr.count > 1
        {
            strNewToOutput = arr[1]
            strNewToOutput = strNewToOutput.replacingOccurrences(of: ": \n\r", with: ": ")
            strNewToOutput = strNewToOutput.replacingOccurrences(of: ":\n\r", with: ": ")
            let arrNew = NSMutableArray.init(array: strNewToOutput.components(separatedBy: "\n\r"))
            arrNew.remove("")
            print(arrNew)
            
            for keyValue in arrNew
            {
                let strKeyValue = "\(keyValue)"
                if strKeyValue.contains(":")
                {
                    var strKey = ""
                    var strValue = ""
                    var isSepratorFound = false
                    var foundCharInKey = false
                    var foundCharInValue = false
                    
                    for word in strKeyValue
                    {
                        if isSepratorFound
                        {
                            if word == " " && !foundCharInValue
                            {
                                
                            }
                            else
                            {
                                foundCharInValue = true
                                strValue = "\(strValue)" + "\(word)"
                            }
                        }
                        else
                        {
                            if word == ":"
                            {
                                isSepratorFound = true
                                continue
                            }
                            if word == " " && !foundCharInKey
                            {
                                
                            }
                            else
                            {
                                foundCharInKey = true
                                strKey = "\(strKey)" + "\(word)"
                            }
                        }
                    }
                    let dic = NSMutableDictionary()
                    dic.setValue("\(strKey)", forKey: "key")
                    dic.setValue("\(strValue)", forKey: "value")
                    self.arrDeliveryTicketData.add(dic)
                    
                    /*let arrKeyValue = strKeyValue.components(separatedBy: ":")
                     if arrKeyValue.count == 2
                     {
                     let dic = NSMutableDictionary()
                     dic.setValue(arrKeyValue[0], forKey: "key")
                     dic.setValue(arrKeyValue[1], forKey: "value")
                     self.arrDeliveryTicketData.add(dic)
                     }*/
                }
            }
            print(self.arrDeliveryTicketData)
            self.tblDeliveryTicket.reloadData()
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segToSignatureVC"
        {
            let VC : SendTicketVC = segue.destination as! SendTicketVC
            VC.dicTicketReport = self.dicTicket
            VC.isSend = sender as? Bool ?? false
        }
        
    }
    
    
}
