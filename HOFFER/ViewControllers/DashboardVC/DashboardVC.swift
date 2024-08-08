//
//  DashboardVC.swift
//  HOFFER
//
//  Created by SiliconMac on 25/07/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit



class DashboardVC: UIViewController, UITextFieldDelegate {
    
    //MARK:- FOR THE TESTING PURPOSE
    
    let testName = "XYZ013485"
    let test_UUID = "HEYTRYAGAINANDGETMOREUUIDWITHAWESOMENAME07"
    
    //MARK:- Outlet & Variable
    
    @IBOutlet var popupPinCodeView: UIView!
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var btnBluetoothConnection: UIButton!
    @IBOutlet weak var btnNavigation: UIButton!
    fileprivate var colorForPeripheral = [UUID: UIColor]()
    
    private var observer: NSObjectProtocol!
    
    var textField: UITextField?
    var button = UIButton(type: .custom)
    var navBar = CustomTitleView()
    
    
    deinit {
       print("deinit")
       
    }
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPinCode.delegate = self
        if let custom = self.navigationController as? CustomNavigationVC {
            custom.isOffline = APPDELEGATE.isBTOffline
        }
        
        //navBar.loadWith(title: "<Unknown: >", leftImage: #imageLiteral(resourceName: "bluetoothDisConnect"))
        //navBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        //self.navigationItem.titleView = navBar
        
        
        popupPinCodeView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        if !APPDELEGATE.isBTOffline {
            
            self.perform(#selector(self.setTimeAndDateOfICEDevice), with: nil, afterDelay: 0.5)
            
            /**
             * VERY IMPORTANT METHODS CALLS
             * CALLING FOR THE SUPER VIEW DID LOAD METHOD FOR THE REGISTER ICE DEVICE DELEGATES
            */
            ICEManagerVC.shared.DidLoad()
            
            // DEVICE SETTING METHODS
            
            if let peripheral = Singleton.sharedSingleton.selectedPeripheral { // CHECKING NAME FOR DEVICE
                var isFound: Bool = false
                for aDevice in Singleton.sharedSingleton.arrDevicesNames {
                    if aDevice.strUUID == peripheral.identifier.uuidString {
                        self.title = aDevice.strName // SET DEVICE NAME HERE
                        isFound = true
                        break
                    }
                }
                
                if !isFound{
                    self.title = Singleton.sharedSingleton.selectedPeripheral?.peripheral.name ?? "<Unknown: >"
                    if FeatureFlags.isDebugClientDesk {
                        Singleton.sharedSingleton.setDevicesName("007", strUUID: peripheral.identifier.uuidString, successBlock: {
                            self.view.squareLoading.stop(delay: 0.0)
                            print("setDevicesName Successfully")
                            for aDevice in Singleton.sharedSingleton.arrDevicesNames {
                                if aDevice.strUUID == Singleton.sharedSingleton.selectedPeripheral?.peripheral.identifier.uuidString {
                                    self.title = aDevice.strName
                                    break
                                }
                            }
                        }, failureBlock: {
                            self.view.squareLoading.stop(delay: 0.0)
                            print("setDevicesName Failed")
                        })
                        return
                    }
                    // OPEN ALERT FOR ASK NAME
                    self.openAlertView(strUUID: peripheral.identifier.uuidString, macID: "")
                }
            }
            else if FeatureFlags.isBypassForScreen {
                
                var isFound: Bool = false
                for aDevice in Singleton.sharedSingleton.arrDevicesNames {
                    if aDevice.strUUID == test_UUID {
                        self.title = aDevice.strName // SET DEVICE NAME HERE
                        isFound = true
                        break
                    }
                }
                if !isFound{
                    self.title = Singleton.sharedSingleton.selectedPeripheral?.peripheral.name ?? testName
                    self.openAlertView(strUUID: test_UUID, macID: "")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.squareLoading.start(delay: 0.0)
        if !APPDELEGATE.isBTOffline {
            /**
             * VERY IMPORTANT METHODS CALLS
             * CALLING FOR THE SUPER VIEW DID LOAD METHOD FOR THE REGISTER ICE DEVICE DELEGATES
             */
            ICEManagerVC.shared.WillAppear(animated: animated)
        }
        /**
         * VERY IMPORTANT METHODS
         * FOR EDIT PROFILE CALLSE
         */
        observer = NotificationCenter.default.addObserver(forName: Notification.Name("NotificationEditClick"), object: nil, queue: .main, using: { (notification) in
            print("Notification.Name(NotificationEditClick)")
            if let peripheral = Singleton.sharedSingleton.selectedPeripheral { // CHECKING NAME FOR DEVICE
                for aDevice in Singleton.sharedSingleton.arrDevicesNames {
                    if aDevice.strUUID == peripheral.identifier.uuidString {
                        self.textField?.text = aDevice.strName // SET DEVICE NAME HERE
                        break
                    }
                }
                self.openAlertView(strUUID: peripheral.identifier.uuidString, macID: "")
            }else if FeatureFlags.isBypassForScreen {
                self.openAlertView(strUUID: self.test_UUID, macID: "")
                for aDevice in Singleton.sharedSingleton.arrDevicesNames {
                    if aDevice.strUUID == self.test_UUID {
                        self.textField?.text = aDevice.strName // SET DEVICE NAME HERE
                        break
                    }
                }
            }
        })
        /**
         * END OF THE NOTIFICAITON OBSERVATION
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //// Start scannning Auto Debuging
        //self.performSegue(withIdentifier: "segToTripReportVC", sender: "")
        ////*******************************************
        if FeatureFlags.isDebugClientDesk {
            // 1=DeliveryTicket
            //2=SavedTicket
            //3=TripReport
            //4=AuditTrail
            //5=MonitorDelivery
            //6=Configuration
            self.btnNavigation.tag = 5
            self.btnTicketCategoriesPressed(self.btnNavigation)
        }
        ////*******************************************
        
        self.view.squareLoading.stop(delay: 0.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(observer as Any)
        super.viewDidDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationEditClick"), object: nil)
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- METHODS FO THE SETTING ICE DEVICE TITLE
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Enter name here";
        }
    }
    
    func openAlertView(strUUID:String, macID:String) {
		let alert = UIAlertController(title: "ICE Device Name", message: "Do you want to set device name?", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Cancel button")
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (UIAlertAction) in
            print("User click Ok button")
            if let strName = self.textField?.text {
                let strDeviceName = strName.trimmingCharacters(in: .whitespacesAndNewlines)
                if strDeviceName.count > 0 {
                    // set for the title call in BG.
                    self.view.squareLoading.start(delay: 0.0)
                    Singleton.sharedSingleton.setDevicesName(strDeviceName, strUUID: strUUID, successBlock: {
                        self.view.squareLoading.stop(delay: 0.0)
                        print("setDevicesName Successfully")
                        self.title = strName
                    }, failureBlock: {
                        self.view.squareLoading.stop(delay: 0.0)
                        print("setDevicesName Failed")
                    })
                }else{
                    // COMMENT FOR NOW
                    /*AJAlertController.initialization().showAlert(aStrMessage: "Device name can't be blank. Do you want to try it again?", aCancelBtnTitle: "No", aOtherBtnTitle: "Yes", completion: { (index, str) in
                        if index == 1 {
                           self.openAlertView(strUUID: strUUID, macID: "")
                        }
                    })*/
                }
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Set ICE Device Clock Time & Date
    
    @objc func setTimeAndDateOfICEDevice(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy::hh:mm"
        //print("Current date: \(formatter.string(from: Date()))") // -> Current date: 08:48:48 PM
        let strCurrentDate = "\(formatter.string(from: Date()))"
        ICEManagerVC.shared.send_SetTimeAndDateOfICEDevice_Command("SC=\(strCurrentDate)") { (strResult) in
            if strResult != "" {
                print("Configuration Came Final" + "\(strResult)")
                self.view.squareLoading.stop(delay: 0.0)
            }else{
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func btnBluetoothConnectionPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func btnDisconnectPressed(_ sender: Any) {
        BleManager.shared.disconnectConnectedDivice()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTicketCategoriesPressed(_ sender: UIButton) {
        
        
        if APPDELEGATE.isBTOffline && sender.tag != 2
        {
                    let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            
                    self.navigationController?.pushViewController(vc!, animated: true)
            //Singleton().showAlertWithSingleButton(strMessage: "Not available in offline.")
            return
        }
        
        if sender.tag == 1
        {
            //Delivery Ticket
            //SEND COMMAND == "RDT"
            self.performSegue(withIdentifier: "segToDeliveryTicketVC", sender: "")
        }
        else if sender.tag == 2
        {
            //Saved Tickets
            self.performSegue(withIdentifier: "segToSavedTicketListVC", sender: "Test Ticket")
        }
        else if sender.tag == 3
        {
            //Trip Report
            //Send Commands: TR0, TR1, TR2, TR3
            self.performSegue(withIdentifier: "segToTripReportVC", sender: "")
        }
        else if sender.tag == 4
        {
            //Audit Trail            
            self.performSegue(withIdentifier: "segToAudit_TrailVC", sender: "")
        }
        else if sender.tag == 5
        {
            //Monitor Delivery
            self.performSegue(withIdentifier: "segToMonitorDeliveryVC", sender: nil)
        }
        else if sender.tag == 6
        {
            //Configuration
            popupPinCodeView.center = view.center
            popupPinCodeView.alpha = 1
            popupPinCodeView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            self.view.addSubview(popupPinCodeView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                //go back to original form
                self.popupPinCodeView.transform = .identity
                self.view.layoutIfNeeded()
            }) { (success) in
                self.txtPinCode.becomeFirstResponder()
            }
            //self.performSegue(withIdentifier: "segToConfigurationVC", sender: "")
        }
    }
    
    
    
    @IBAction func btnContinuePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let strPin = self.txtPinCode.text!.trimmingCharacters(in: .whitespaces)
        guard strPin.count > 0 else {
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strNoPin)
            return
        }
        guard strPin == strDefaultPin || strPin == strBackDoorPin else {
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: strWrongPin)
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupPinCodeView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.popupPinCodeView.alpha = 0
        }) { (success) in
            self.txtPinCode.text = ""
            self.popupPinCodeView.removeFromSuperview()
            self.performSegue(withIdentifier: "segToConfigurationVC", sender: "")
        }
        
    }
    
    @IBAction func btnClosePressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.popupPinCodeView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.txtPinCode.text = ""
            self.popupPinCodeView.removeFromSuperview()
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
    
    
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segToDeliveryTicketVC"
        {
            let VC : DeliveryTicketVC = segue.destination as! DeliveryTicketVC
            VC.strOutPut = sender as! String
        }
        else if segue.identifier == "segToSavedTicketListVC"
        {
            //let aSavedTicket : SavedTicketListVC = segue.destination as! SavedTicketListVC
        }
        else if segue.identifier == "segToConfigurationVC"
        {
            //let aConfigure : ConfigurationVC = segue.destination as! ConfigurationVC
            //aConfigure.strOutPut = sender as? String ?? ""
        }
        else if segue.identifier == "segToTripReportVC"
        {
            let aConfigure : TripReportVC = segue.destination as! TripReportVC
            aConfigure.strOutPut = sender as? String ?? ""
        }
    }
}

class CustomTitleView: UIView
{
    
    var title_label = UILabel()
    var left_imageView = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        self.addSubview(title_label)
        self.addSubview(left_imageView)
        //addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    //MARK:- ADD CLOSURE FOR THE TAP EVENT
    
   
    
    func loadWith(title: String, leftImage: UIImage?)
    {
        
        //self.backgroundColor = .yellow
        
        // =================== title_label ==================
        //title_label.backgroundColor = .blue
        title_label.text = title
        title_label.font = UIFont.boldSystemFont(ofSize: 15.0)
        title_label.textColor = UIColor.white
        
        // =================== imageView ===================
        left_imageView.image = leftImage
        
        setupFrames()
    }
    
    func setupFrames()
    {
        
        let height: CGFloat = 44
        let image_size: CGFloat = height * 0.8
        let titleWidth: CGFloat = title_label.intrinsicContentSize.width + 10
        
        title_label.frame = CGRect(x: 0,
                                   y: 0,
                                   width: titleWidth,
                                   height: height)
        
        left_imageView.frame = CGRect(x: title_label.frame.maxX + 5,
                                      y: (height - image_size) / 2,
                                      width: (left_imageView.image == nil) ? 0 : image_size,
                                      height: image_size)

        contentWidth = Int(left_imageView.frame.width + title_label.frame.width)
        self.frame = CGRect(x: 0, y: 0, width: CGFloat(contentWidth), height: height)
    }
    
    
    var contentWidth: Int = 0 //if its CGFloat, it infinitely calls layoutSubviews(), changing franction of a width
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.width = CGFloat(contentWidth)
        
    }
    
}

