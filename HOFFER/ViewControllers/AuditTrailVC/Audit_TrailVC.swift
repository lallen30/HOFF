//
//  Audit_TrailVC.swift
//  HOFFER
//
//  Created by macmini on 21/09/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import ContactsUI

class Audit_TrailVC: UIViewController, UITextFieldDelegate, CNContactPickerDelegate {
    
    
    //When no data available
    //"AT1\nAT1\nProcessMsg::command == AT1\n\rPrinting Audit Trail\n\rPrint Audit Log attempted while delivery\n\r"
    
    
    //When data available.
    //"AT0\nAT0\nProcessMsg::command == AT0\n\rPrinting Audit Trail\n\r  \n\rBEGIN AUDIT TRAIL\n\rDATE: 09/26/2001\n\rTIME : 10:31\u{03}\n\r \n\r1 09/21/2001::09:55 DFP\n\r250.000 113.696 psia\n\r2 09/21/2001::10:01 DFT\n\r110.000 K 99.000 K\n\r3 09/21/2001::10:06 DLU\n\rGAL@NBP POUND\n\r4 09/21/2001::10:10 CPM\n\rTDP NONE\n\r5 09/21/2001::10:36 FLU\n\rLIN CO2S\n\r6 09/21/2001::10:48 MSZ\n\r2.00  1.50\n\r7 09/26/2001::10:28 DFP\n\r350.000 214.696 psia\n\r  \n\rEND OF AUDIT TRAIL\n\r"

    @IBOutlet weak var tblAuditTrais: UITableView!
    @IBOutlet weak var btnPageDropDown: UIButton!
    @IBOutlet var popupEmailView: UIView!
    @IBOutlet weak var btnSendEmail: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    var arrAuditTrailEntries = NSMutableArray()
    var strOutPut = ""
    var loadingData: Bool = false
    var page : Int! {
        didSet{
            if page == 0 { // 10 records
                self.btnPageDropDown.setTitle("10 Entries ▼", for: .normal)
            }else if page == 1 { // 20
                self.btnPageDropDown.setTitle("20 Entries ▼", for: .normal)
            }else if page == 2 { // 50
                self.btnPageDropDown.setTitle("50 Entries ▼", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page = 0
        popupEmailView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.tblAuditTrais.estimatedRowHeight = 135
		self.tblAuditTrais.rowHeight = UITableView.automaticDimension
        
        //FIRE FIRST PAGE COMMAND
        self.getAuditTrailEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
    
    //MARK:- BUTTON ACTIONS
    @IBAction func btnPageClick (_ sender:UIButton){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["10 Entries","20 Entries","50 Entries"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.page = index
                self.getAuditTrailEntries()
            }
        })
    }
	
	
	@IBAction func btnBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	
    
    //MARK:- IBOutlets & Variables Declaration
    func createArrayOfReports() {
        let arrResult : NSMutableArray  = self.strOutPut.ConvertArduino_AT_Command_ToArray()
        if arrResult.count > 0
        {
            self.arrAuditTrailEntries.removeAllObjects()
            self.arrAuditTrailEntries = NSMutableArray(array: arrResult.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
            self.tblAuditTrais.reloadData()
        }
        else
        {
            if page > 0
            {
                return
            }
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Something went wrong, Please try again or reset you ICE device.") { (index, title) in
                self.perform(#selector(self.goBack), with: nil, afterDelay: 0.6)
            }
        }
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAuditTrailEntries(){
        self.view.squareLoading.start(delay: 0.0)
        loadingData = true
        ICEManagerVC.shared.send_AT_Commands (page.description, { (strResult) in
            
            self.view.squareLoading.stop(delay: 0.0)
            if strResult != "" {
                self.loadingData = false
                print("Configuration Came Final" + "\(strResult)")
                self.strOutPut = strResult
                DispatchQueue.main.async {
                    self.createArrayOfReports()
                }
            }else {
                self.arrAuditTrailEntries.removeAllObjects()
                self.tblAuditTrais.reloadData()
                self.loadingData = false
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
            }
            
        })
    }
    
    
    //MARK:- User define methods.
    
    func Call_sendEmail(strEmail:String) -> Void {
        let dicInput = NSMutableDictionary()
        dicInput.setValue(strEmail, forKey: "email")
        let jsonData = try? JSONSerialization.data(withJSONObject: self.arrAuditTrailEntries, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        //jsonString = jsonString?.replacingOccurrences(of: "[", with: "(")
        //jsonString = jsonString?.replacingOccurrences(of: "]", with: ")")
        dicInput.setValue("\(jsonString!)", forKey: "config_json")
        dicInput.setValue("1", forKey: "array_json")
        dicInput.setValue("1", forKey: "report_type") // for audit
        
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
    
    
    
    @IBAction func btnSendPressed(_ sender: UIButton) {
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
    
    @IBAction func btnSaveCloseclick(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupEmailView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.popupEmailView.removeFromSuperview()
        }
    }
    
    
    
}

extension Audit_TrailVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAuditTrailEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Audit_TrailCell", for: indexPath) as! Audit_TrailCell
        let dic = self.arrAuditTrailEntries.object(at: indexPath.row) as! NSDictionary
        cell.lblDate.text = "\(dic.value(forKey: "date") ?? "-")".replace("-", replacement: "  ")//Replace space
        cell.lblAuditNo.text = "   Entry: \(indexPath.row + 1)   "
        cell.lblName.text = "\(dic.value(forKey: "type") ?? "-"):"
        let value1 = "\(dic.value(forKey: "value1") ?? "-")"
        let value2 = "\(dic.value(forKey: "value2") ?? "-")"
        let unit = "\(dic.value(forKey: "unit") ?? "-")"
        cell.lblRecord.text = "\(value1)  \(value2 == "-" ? unit: value2+"  "+unit)"
        return cell
    }
    
}


