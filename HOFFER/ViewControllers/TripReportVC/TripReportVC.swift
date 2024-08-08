//
//  TripReportVC.swift
//  HOFFER
//
//  Created by Admin on 14/09/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import ContactsUI

class TripReportVC: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CNContactPickerDelegate {
    
    //MARK:- IBOutlets & Variables Declaration
    @IBOutlet weak var tblTripReports: UITableView!
    @IBOutlet weak var btnPageDropDown: UIButton!
    @IBOutlet var popupEmailView: UIView!
    @IBOutlet weak var btnSendEmail: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    var arrTripReports = NSMutableArray()
    var strOutPut = ""
    var page : Int! {
        didSet{
            if page == 0 { // 10 records
               self.btnPageDropDown.setTitle("10 Records ▼", for: .normal)
            }else if page == 1 { // 20
               self.btnPageDropDown.setTitle("20 Records ▼", for: .normal)
            }else if page == 2 { // 40
               self.btnPageDropDown.setTitle("40 Records ▼", for: .normal)
            }else if page == 3 { // 100
               self.btnPageDropDown.setTitle("100 Record ▼", for: .normal)
            }
        }
    }
    var loadingData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page = 0
        popupEmailView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//		self.navigationItem.leftBarButtonItem?.tintColor = .black
//		if #available(iOS 13.0, *) {
//			let appearance = UINavigationBarAppearance()
//			appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//			navigationController?.navigationBar.standardAppearance = appearance
//			navigationController?.navigationBar.scrollEdgeAppearance = appearance
//		} else {
//			self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//		}
        //FIRE FIRST PAGE COMMAND
        self.GetTripReport()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func scrollToBottom() {
        self.tblTripReports.scrollToRow(at: IndexPath(row: self.arrTripReports.count-1, section: 0), at: .bottom, animated: true)
    }
    
    //MARK:- BUTTON ACTIONS
    @IBAction func btnPageClick (_ sender:UIButton){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["10 Records","20 Records","40 Records","100 Records"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.page = index
                self.GetTripReport()
            }
        })
    }
    
	
	@IBAction func btnBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	
	
    //MARK:- IBOutlets & Variables Declaration
    func createArrayOfReports() {
        let arrResult : NSMutableArray  = self.strOutPut.ConvertArduinoTRCommandToArray()
        if arrResult.count > 0
        {
            self.arrTripReports.removeAllObjects()
            self.arrTripReports = NSMutableArray(array: arrResult.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
            self.tblTripReports.reloadData()           
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
    
    func GetTripReport(){
        self.view.squareLoading.start(delay: 0.0)
        loadingData = true
        ICEManagerVC.shared.send_TR_Commands(page.description, { (strResult) in
            
            self.view.squareLoading.stop(delay: 0.0)
            if strResult != "" {
                self.loadingData = false
                print("Configuration Came Final" + "\(strResult)")
                self.strOutPut = strResult
                DispatchQueue.main.async {
                    self.createArrayOfReports()
                }
            }else {
                self.loadingData = false
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
            }
        })
    }
    
    
    
    
    //MARK:- User define methods.
    
    func Call_sendEmail(strEmail:String) -> Void {
        let dicInput = NSMutableDictionary()
        dicInput.setValue(strEmail, forKey: "email")
        let jsonData = try? JSONSerialization.data(withJSONObject: self.arrTripReports, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        //jsonString = jsonString?.replacingOccurrences(of: "[", with: "(")
        //jsonString = jsonString?.replacingOccurrences(of: "]", with: ")")
        dicInput.setValue("\(jsonString!)", forKey: "config_json")
        dicInput.setValue("1", forKey: "array_json")
        dicInput.setValue("2", forKey: "report_type") // FOR TRIP
        
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
    
    
    
    //MARK:- UITableView Delegates and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTripReports.count;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*if arrTripReports.count > 8 && !loadingData && indexPath.row ==  arrTripReports.count - 1 && self.page < 4 {
            self.loadMoreData()
        }*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripReportCell", for: indexPath) as! TripReportCell
        let dic = self.arrTripReports.object(at: indexPath.row) as! NSMutableDictionary
        cell.lblTrailorNo.text = "\(dic.value(forKey: "trailer_number") ?? "-")"
        cell.lblDate.text = "\(dic.value(forKey: "date") ?? "-")"
        cell.lblTime.text = "\(dic.value(forKey: "time") ?? "-")"
        cell.lblAccumulatedTotal.text = "\(dic.value(forKey: "accumulated_total") ?? "-")"
        cell.lblDelivery.text = "\(dic.value(forKey: "delivery") ?? "-")"
        cell.lblDeliveryNo.text = "\(dic.value(forKey: "delivery_number") ?? "-")"
        cell.lblProductName.text = "\(dic.value(forKey: "product_name") ?? "-")"
        cell.lblUnit.text = "\(dic.value(forKey: "units") ?? "-")"
        cell.lblError.text = "\(dic.value(forKey: "error") ?? "-")"
        cell.lblRecordNumber.text = "   Record: \(indexPath.row+1)   "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dic = self.arrTripReports.object(at: indexPath.row) as! NSMutableDictionary
        if "\(dic.value(forKey: "error") ?? "-")" == "nil" {
            return 345
        }
        return 395
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let dic = self.arrTripReports.object(at: indexPath.row) as! NSMutableDictionary
        if "\(dic.value(forKey: "error") ?? "-")" == "nil" {
            return 345
        }
        return 395
    }
}
