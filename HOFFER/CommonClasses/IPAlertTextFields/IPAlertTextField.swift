//
//  IPAlertTextField.swift
//  HOFFER
//
//  Created by macmini on 24/09/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class IPAlertTextField: UIViewController {

    var strTitle : String = ""
    var type :configType!
    
    var strSendValue : String = ""
    
    @IBOutlet var viewAlert: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    /// AlertController Completion handler
    typealias alertCompletionBlock = (() -> Void)?
    private var block : alertCompletionBlock?
    
    //MARK:- VIEW DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAJAlertController()
        txtValue.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK:- SETUP VIEWS AND DATA
    private func setupAJAlertController(){
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.alpha = 0.6
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped)))
        self.view.insertSubview(visualEffectView, at: 0)
        
        //viewAlert.clipsToBounds = false
       // viewAlert.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        
        //TEXTS
    }
    //MARK:- SETUP DATA INTO THE VIEW ALERTS
    func setUpviewData () {
        lblTitle.text = strTitle
        if type == .reference {
            txtValue.placeholder = "Select reference"
        }
        else if type == .temperature_unit {
            txtValue.placeholder = "Select Temperature units"
        }
        else if type == .default_temperature {
            txtValue.placeholder = "Enter Default temperature"
        }
        else if type == .pressure_unit {
            txtValue.placeholder = "Select Pressure units"
        }
        else if type == .default_pressure {
            txtValue.placeholder = "Enter Default pressure "
        }
        else if type == .delivery_unit {
            txtValue.placeholder = "Select Delivery units"
        }
        else if type == .total_decimal_places {
             txtValue.placeholder = "Select Total decimal places"
        }
        else if type == .fluid_type {
            txtValue.placeholder = "Select Fluid type"
        }
        else if type == .display {
            txtValue.placeholder = "Enter Display T/O"
        }
        else if type == .compensation_method {
            txtValue.placeholder = "Select Compensation methond"
        }
        else if type == .pump_delay {
            txtValue.placeholder = "Enter Delay time"
        }else if type == .trailer_number {
            txtValue.placeholder = "Enter Trailer number"
        }else if type == .serial_number {
            txtValue.placeholder = "Enter Serial number"
        }else if type == .Meter_size {
            txtValue.placeholder = "Select Meter size"
        }else if type == .kfactor_method {
            txtValue.placeholder = "Select K-factor method"
        }else if type == .average_kfactor {
            txtValue.placeholder = "Enter Average K-factor"
        }else if type == .Frequency_1 || type == .Frequency_2 || type == .Frequency_3 || type == .Frequency_4 || type == .Frequency_5{
            txtValue.placeholder = "Enter Frequency"
        }else if type == .kfactor_1 || type == .kfactor_2 || type == .kfactor_3 || type == .kfactor_4 || type == .kfactor_5{
            txtValue.placeholder = "Enter K-factor"
        }
        else{
            txtValue.placeholder = ""
        }
    }
    
    static func initialization() -> IPAlertTextField {
        let alertController = IPAlertTextField(nibName: "IPAlertTextField", bundle: nil)
        return alertController
    }
    
    public func showAlert( strUrl:String?,typeSettings:configType,
                           completion : alertCompletionBlock){
        /*guard !Singleton.shared.isAlertPresented else {
            return
        }*/
        self.strTitle = strUrl ?? ""
        self.type = typeSettings
        show()
        block = completion
    }

    //MARK:- COMMANDS METHODS
    
    
    //MARK: UIBUTTON ACTIONS
    @IBAction func btnSaveClick(_ sender: UIButton) {
        self.txtValue.resignFirstResponder()
        if strSendValue != "" {
            if type == .reference {
                //REF=0
                self.sendCommand(strCommand: "REF=\(strSendValue)")
            }
            else if type == .temperature_unit {
                //TEU=0
                self.sendCommand(strCommand: "TEU=\(strSendValue)")
            }
            else if type == .default_temperature {
                //DFT=0
                if isValid_DefaultTemparature() {
                    self.sendCommand(strCommand: "DFT=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be -500 to 500")
                }
            }
            else if type == .pressure_unit {
                //PRU=0
                self.sendCommand(strCommand: "PRU=\(strSendValue)")
            }
            else if type == .total_decimal_places {
                //TD=2
                self.sendCommand(strCommand: "TD=\(strSendValue)")
            }
            else if type == .default_pressure {
                //DFP=200
                if isValid_DefaultPressur() {
                    self.sendCommand(strCommand: "DFP=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.0 to 1500.0")
                }
            }
            else if type == .delivery_unit {
                //DLU=0
                self.sendCommand(strCommand: "DLU=\(strSendValue)")
            }
            else if type == .fluid_type {
                //GAS=0
                self.sendCommand(strCommand: "GAS=\(strSendValue)")
            }
            else if type == .display {
               
            }
            else if type == .compensation_method {
                //CPM=0
                self.sendCommand(strCommand: "CPM=\(strSendValue)")
            }
            else if type == .pump_delay {
                //DLY= TIME IN MINUTE
                self.sendCommand(strCommand: "DLY=\(strSendValue)")
            }else if type == .trailer_number {
                //TRL= Trailer identification number
                self.sendCommand(strCommand: "TRL=\(strSendValue)")
            }else if type == .serial_number {
                //TUR= Integer, 9 digits
                self.sendCommand(strCommand: "TUR=\(strSendValue)")
            }else if type == .Meter_size {
                //MSZ= 0
                self.sendCommand(strCommand: "MSZ=\(strSendValue)")
            }else if type == .kfactor_method {
                //FC= 0
                self.sendCommand(strCommand: "FC=\(strSendValue)")
            }else if type == .average_kfactor {
                //AK= 100
                self.sendCommand(strCommand: "AK=\(strSendValue)")
            }else if type == .Frequency_1 {
                //F01= 12345.678
                if isValid_Frequency(){
                    self.sendCommand(strCommand: "F01=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.100 to < 5000.001")
                }
            }
            else if type == .Frequency_2 {
                //F02= 12345.678
                if isValid_Frequency(){
                    self.sendCommand(strCommand: "F02=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.100 to < 5000.001")
                }
            }
            else if type == .Frequency_3 {
                //F03= 12345.678
                if isValid_Frequency(){
                    self.sendCommand(strCommand: "F03=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.100 to < 5000.001")
                }
            }else if type == .Frequency_4 {
                //F03= 12345.678
                if isValid_Frequency(){
                    self.sendCommand(strCommand: "F04=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.100 to < 5000.001")
                }
            }else if type == .Frequency_5 {
                //F03= 12345.678
                if isValid_Frequency(){
                    self.sendCommand(strCommand: "F05=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.100 to < 5000.001")
                }
            }
            else if type == .kfactor_1 {
                //K01= 12345.678
                if isValid_K_factor(){
                    self.sendCommand(strCommand: "K01=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.001 to 99999.999")
                }
            }else if type == .kfactor_2 {
                //K02= 12345.678
                if isValid_K_factor(){
                    self.sendCommand(strCommand: "K02=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.001 to 99999.999")
                }
            }else if type == .kfactor_3 {
                //K03= 12345.678
                if isValid_K_factor(){
                    self.sendCommand(strCommand: "K03=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.001 to 99999.999")
                }
            }else if type == .kfactor_4 {
                //K03= 12345.678
                if isValid_K_factor(){
                    self.sendCommand(strCommand: "K04=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.001 to 99999.999")
                }
            }else if type == .kfactor_5 {
                //K03= 12345.678
                if isValid_K_factor(){
                    self.sendCommand(strCommand: "K05=\(strSendValue)")
                }else{
                    Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value range should be 0.001 to 99999.999")
                }
            }
        }else{
            Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "Value can't be blank.")
        }
    }
    
    //MAKR:- VALIDATION METHODS FOR THE COMMANDS
    func isValid_DefaultPressur()->Bool {
        //Floating point number in range 0.0 to 1500.00
        if let value = Double(txtValue.text!), value >= 0.0 && value <= 1500.00 {
            return true
        }else if let value = Int(txtValue.text!),value >= 0 && value <= 1500 {
            return true
        }else{
            return false
        }
    }
    
    func isValid_DefaultTemparature()->Bool {
        //DFT - Floating point number in range -500 to 500.
        if let value = Double(txtValue.text!), value >= -500.0 && value <= 500.0 {
            return true
        }else if let value = Int(txtValue.text!),value >= -500 && value <= 500 {
            return true
        }else{
            return false
        }
    }

    func isValid_K_factor()->Bool {
        //Range restricted 0.001 to 99999.999.
        if let value = Double(txtValue.text!), value >= 0.001 && value <= 99999.999 {
            return true
        }else{
            return false
        }
    }
    
    func isValid_Frequency()->Bool {
        //Restricted to range 0.100 to < 5000.001
        if let value = Double(txtValue.text!), value >= 0.100 && value <= 5000.001 {
            return true
        }else{
            return false
        }
    }
    
    //MARK:- VIEW PRESENT METHDOS
    private func show() {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            
			topViewController.addChild(self)
            topViewController.view.addSubview(view)
            viewWillAppear(true)
			didMove(toParent: topViewController)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.alpha = 0.0
            view.frame = topViewController.view.bounds
            
            viewAlert.alpha     = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.view.alpha = 1.0
            }, completion: nil)
            
            viewAlert.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-10)
            UIView.animate(withDuration: 0.2 , delay: 0.1, options: .curveEaseOut, animations: { () -> Void in
                self.viewAlert.alpha = 1.0
                self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0))
            }, completion: nil)
            self.setUpviewData()
        }
    }
    /// Hide Alert Controller on background tap
    @objc func backgroundViewTapped(sender:AnyObject) {
        hide()
    }
    /// Hide Alert Controller
    private func hide()
    {
        self.view.endEditing(true)
        self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.viewAlert.alpha = 0.0
            self.viewAlert.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-5)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.05, options: .curveEaseIn, animations: { () -> Void in
            self.view.alpha = 0.0
            
        }) { (completed) -> Void in
            self.view.removeFromSuperview()
			self.removeFromParent()
        }
    }
    //MARK:- SEND CONFIGURATATION COMMAND
    func sendCommand(strCommand:String){
        self.view.squareLoading.start(delay: 0.0)
        ICEManagerVC.shared.send_SetConfigure_Command(strCommand) { (strResult) in
            if strResult != "" {
                if strResult.contains("Input Out Of Range") {
                    Singleton().showAlertWithSingleButton(strMessage: "Input Out Of Range")
                }
                print("send_SetConfigure_Command" + "\(strResult)")
                self.block!!()
                self.hide()
            }else {
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
            }
            DispatchQueue.main.async {
               self.view.squareLoading.stop(delay: 0.0)
            }
        }
    }
    
    //MARK:- SHOW DROPDOWN
    func showDropDown_DeliveryUnit(){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["GALLONS","LITERS","GALLONS @ NBP","LITERS @ NBP","SCF @ NTP","SCFX 100","SCM @ NTP","POUNDS","KILOGRAMS"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
    func showDropDown_TemperatureUnit(){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["Kelvin","Farenheit","Centigrade"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description //TEU
            }
        })
    }
    
    func showDropDown_MeterTurbine_Size(){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        /*CHANGE: Configuration: Meter Size options after 2.0 (4) are shown as tbd1, tbd2 and tbd3.  There should be 2.5" (5) and 3.0" (6).  Will check firmware to see if device is sending this way.
         */
        let arrTitle = ["0.75","1.00","1.25","1.50","2.00","2.50","3.00"] //["0.75","1.00","1.25","1.50","2.00","tbd1","tbd2","tbd3"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
    func showDropDown_PressureUnit(){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["psia","psig","bar-a","bar-g"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
    func showDropDown_FuildType(){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["LIN","LOX","LAR","CO2 single","CO2 dual","N2O","LNG-93","LNG-95","LNG-97","Volumetric (only)"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
    func showDropDown_Compensation_Method(){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["None","Temperature","Temperature & Pressure","Temperature & Def Pressure"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
    func showDropDown_Flow_calculation_method (){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["average Kfactor","linearization"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
    func showDropDown_ReferenceCondition (){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["NIST (70 F, 14.7 psia)","OIML (15 C, 101.325 kPa)","PTB (15 C, 1 bar)","SIRIM (30 C, 101.325 kPa)","ASIAN (27 C, 101.325 kPa)","NORMAL (0 C, 101.325 kPa)"]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
    func showDropDown_DecimalarrList (){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["000","00.0","0.00",]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
    func showDropDown_(){
        var picker : IPDataPicker?
        picker = IPDataPicker.getFromNib()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let arrTitle = ["000","00.0","0.00",]
        picker!.show(arrTitle,(appDelegate.window?.rootViewController)!, withCompletionBlock: { (index , isCancel) in
            print(index)
            if !isCancel {
                self.txtValue.text = arrTitle[index]
                self.strSendValue = index.description
            }
        })
    }
    
}

extension IPAlertTextField : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if type == .reference {
            self.showDropDown_ReferenceCondition()
            return false
        }
        else if type == .temperature_unit {
            self.showDropDown_TemperatureUnit()
            return false
        }
        else if type == .default_temperature {
            self.txtValue.keyboardType = .numbersAndPunctuation
        }
        else if type == .pressure_unit {
            self.showDropDown_PressureUnit()
            return false
        }
        else if type == .total_decimal_places {
            //self.txtValue.keyboardType = .numberPad
            self.showDropDown_DecimalarrList()
            return false
        }
        else if type == .default_pressure {
            self.txtValue.keyboardType = .numberPad
        }
        else if type == .delivery_unit {
            self.showDropDown_DeliveryUnit()
            return false
        }
        else if type == .fluid_type {
            self.showDropDown_FuildType()
            return false
        }
        else if type == .display {
            self.txtValue.keyboardType = .decimalPad
        }
        else if type == .compensation_method {
            self.showDropDown_Compensation_Method()
            return false
        }
        else if type == .pump_delay {
            self.txtValue.keyboardType = .decimalPad
        }else if type == .trailer_number {
            self.txtValue.keyboardType = .numberPad
        }else if type == .serial_number {
            self.txtValue.keyboardType = .numberPad
        }else if type == .Meter_size {
            self.showDropDown_MeterTurbine_Size()
            return false
        }else if type == .kfactor_method {
            self.showDropDown_Flow_calculation_method()
            return false
        }else if type == .average_kfactor {
            self.txtValue.keyboardType = .decimalPad
        }else if type == .Frequency_1 || type == .Frequency_2 || type == .Frequency_3 || type == .Frequency_4 || type == .Frequency_5{
            self.txtValue.keyboardType = .decimalPad
        }else if type == .kfactor_1 || type == .kfactor_2 || type == .kfactor_3 || type == .kfactor_4 || type == .kfactor_5{
            self.txtValue.keyboardType = .decimalPad
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.strSendValue = textField.text!
    }
}
