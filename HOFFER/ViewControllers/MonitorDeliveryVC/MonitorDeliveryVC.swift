//
//  MonitorDeliveryVC.swift
//  HOFFER
//
//  Created by SiliconMac on 26/07/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class MonitorDeliveryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlets & Variables
    @IBOutlet weak var tblDeliveryTicket: UITableView!
    @IBOutlet weak var sliderFlowRate: UISlider!
    @IBOutlet weak var sliderTemperature: UISlider!
    @IBOutlet weak var sliderPressure: UISlider!
    @IBOutlet weak var lblDeliveryValue: UILabel!
    @IBOutlet weak var lblFlowRateValue: UILabel!
    @IBOutlet weak var lblTempratureValue: UILabel!
    @IBOutlet weak var lblPressureValue: UILabel!
    @IBOutlet weak var tmpExp: UILabel!
    
    //ERROR LIST
    @IBOutlet weak var viewErrorBottom: UIView!
    @IBOutlet weak var lblErrors: UILabel!
    @IBOutlet weak var lblDeliveryUnit: UILabel!
    
    //@IBOutlet weak var cnsViewHight: NSLayoutConstraint!
    var strDeliveryUnit : String = "" //gallons
    var isShowRedBoxError : Bool!{
        didSet{
            if isShowRedBoxError {
                self.viewErrorBottom.isHidden = false
                //self.cnsViewHight.constant = 70
            }else{
                self.viewErrorBottom.isHidden = true
                //self.cnsViewHight.constant = 0
            }
        }
    }
    
    var strReferance = ""
    var strFluid = ""
    var strAccumulatedTotal = ""
    var dicMonitorDelivery = NSMutableDictionary()
    let arrDeliveryParameters : NSMutableArray = ["REFERENCE T&P",
                                                   "FLUID",
                                                   "ACCUMULATED TOTAL"]
    
    var arrDeliveryParametersValues : NSMutableArray = ["-",
                                                         "-",
                                                         "-"]
    var isScheduleForUSCommand: Bool = false
    
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setConfigureData()
        isShowRedBoxError = false
        self.view.squareLoading.start(delay: 0.0)
        self.send_DA_CommandData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	
	func setConfigureData (){
		self.navigationItem.titleView?.isHidden = false
		self.navigationItem.leftBarButtonItem?.tintColor = .black
		if #available(iOS 13.0, *) {
			let appearance = UINavigationBarAppearance()
			appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
			navigationController?.navigationBar.standardAppearance = appearance
			navigationController?.navigationBar.scrollEdgeAppearance = appearance
		} else {
			self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
		}

	}
    
    //MARK:- Command Methods.
    /// 1ST
    func send_DA_CommandData(){
        //self.view.squareLoading.start(delay: 0.0)
        ICEManagerVC.shared.send_DA_Command { (strResult) in
            self.view.squareLoading.stop(delay: 0.0)
            if strResult != ""
            {
                print("Configuration Came Final" + "\(strResult)")
                let arrResult = strResult.ConvertArduinoDACommandToArray()
                if arrResult.count > 0 {  //Reference conditions //Delivery units //Fluid type
                    for element in arrResult {
                        if let key = element["key"] as? String , key.lowercased().range(of: "Reference".lowercased()) != nil {
                            self.arrDeliveryParametersValues.replaceObject(at: 0, with: element["value"] as? String ?? "-")
                        }else if let key = element["key"] as? String, key.lowercased() == "Delivery units".lowercased(){
                            if let value = element["value"] as? String {
                                if let str = value.slice(from: "(", to: ")") {
                                    self.strDeliveryUnit = str
                                }else if !value.contains(find: ")") && value.contains(find: "("){
                                    let index = value.index(value.range(of: "(")!.upperBound, offsetBy: 0)
                                    self.strDeliveryUnit = String(value[index...])
                                }else{
                                    self.strDeliveryUnit = value
                                }
                            }
                        }else if let key = element["key"] as? String , key.lowercased() == "Fluid type".lowercased(){
                            self.arrDeliveryParametersValues.replaceObject(at: 1, with: element["value"] as? String ?? "-")
                        }
                    }
                    self.tblDeliveryTicket.reloadData()
                }
                else
                {
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Something went wrong, Please try again or reset you ICE device.") { (index, title) in
                        
                    }
                }
                
            }else{
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
            }
            self.send_US_CommandData()
        }
    }
    
    /***
     REMOVE NOW : REPLACE WITH DA COMMAND
    */
    
    /*func sendREFCommandData() {
        //COMAND FOR CONFIGURATION.
        ICEManagerVC.shared.sendREFCommand { (strResult) in
            if strResult != ""
            {
                print("REF Came Final" + "\(strResult)")
                //self.view.squareLoading.stop(delay: 0.0)
                let strRefCondition = strResult.ConvertArduinoREFMonitoringCommandToDicationary()
                self.arrDeliveryParametersValues.replaceObject(at: 0, with: strRefCondition)
                self.tblDeliveryTicket.reloadData()
            }else{
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong when fetching REF value.")
            }
            self.sendGASCommandData()
        }
        
    }
    
    /// 2ND
    func sendGASCommandData() {
        //COMAND FOR CONFIGURATION.
        //self.view.squareLoading.start(delay: 0.0)
        ICEManagerVC.shared.sendGASCommand { (strResult) in
            if strResult != ""
            {
                print("GAS Came Final" + "\(strResult)")
                //self.view.squareLoading.stop(delay: 0.0)
                let strFluidType = strResult.ConvertArduinoGASMonitoringCommandToDicationary()
                self.arrDeliveryParametersValues.replaceObject(at: 1, with: strFluidType)
                self.tblDeliveryTicket.reloadData()
            }else{
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong when fetching GAS value.")
            }
            self.sendDLUCommandData()
        }
        
    }
    
    func sendDLUCommandData() {
        //COMAND FOR CONFIGURATION.
        ICEManagerVC.shared.sendDLUCommand { (strResult) in
            if strResult != ""
            {
                print("DLU Final Resule: " + "\(strResult)")
                let strFluidType = strResult.ConvertArduinoDLUMonitoringCommandToDicationary()
                //self.arrDeliveryParametersValues.replaceObject(at: 1, with: strFluidType)
                if let str = strFluidType.slice(from: "(", to: ")") {
                  self.strDeliveryUnit = str
                }else if !strFluidType.contains(find: ")") {
                    let index = strFluidType.index(strFluidType.range(of: "(")!.upperBound, offsetBy: 0)
                    self.strDeliveryUnit = String(strFluidType[index...])
                }else{
                  self.strDeliveryUnit = strFluidType
                }
                self.tblDeliveryTicket.reloadData()
            }else{
                Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong when fetching DLU value.")
            }
            self.send_US_CommandData()
        }
    }*/
    
    // 3rd
    func send_US_CommandData() {
        //COMAND FOR CONFIGURATION.
        ICEManagerVC.shared.send_US_Command { (strResult) in
            if strResult != ""
            {
                print("US Came Final" + "\(strResult)")
                self.isShowRedBoxError = false
                let strRefCondition = strResult.ConvertArduino_US_CommandToErrorString()
                if strRefCondition.0 {
                    //Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong when fetching value.")
                    /*AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Something Went Wrong when fetching value.") { (index, title) in
                       
                    }*/
                }else{
                    print(strRefCondition.1)
                    if let errorMsg = Int32(strRefCondition.1)?.binaryDescription {
                        print(errorMsg)
                        var strError : [String] = []
                        //let newResult = errorMsg.reversed()
                        for (index, char) in errorMsg.reversed().enumerated() {
                            if char == Character("1"){
                                //print("Errors :- \(arrICEErrors[index])")
                                strError.append(arrICEErrors[index])
                            }
                        }
                        print("- \(strError.joined(separator: ".\n- "))")
                        self.isShowRedBoxError = true
                        self.lblErrors.text = "- \(strError.joined(separator: ".\n- "))"
                    }else{
                        print("Not valid error for parsing:- \(strRefCondition.1)")
                    }
                }
                self.isScheduleForUSCommand = false
                self.sendAACommandData()
            }else{
                /*AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Something Went Wrong when fetching value.") { (index, title) in
                }*/
                self.sendAACommandData() //////--------> Monitor command
            }
        }
    }
    
    // 4rth
    func sendAACommandData() {
        //COMMAND FOR CONFIGURATION.
        //self.view.squareLoading.start(delay: 0.0)
        ICEManagerVC.shared.send_DELIVERY_START_Commands { (strResult) in
            self.view.squareLoading.stop(delay: 0.0)
            if strResult != ""
            {
                print("Configuration Came Final" + "\(strResult)")
                self.dicMonitorDelivery = strResult.ConvertArduinoAAMonitoringCommandToDicationary()
                self.updateSlidersValue()
            }
            else
            {
                //Singleton().showAlertWithSingleButton(strMessage: "Something Went Wrong.")
            }
            if !self.isScheduleForUSCommand {
               self.perform(#selector(self.stopUpdatingForUSCommand), with: nil, afterDelay: 30.0)
               self.isScheduleForUSCommand = true
            }
        }
        
        if FeatureFlags.isDebugClientDesk
        {
            self.perform(#selector(self.stopUpdating), with: nil, afterDelay: 11.0)
        }
    }
    
    func updateSlidersValue() {
        
        let strFlowRate = "\(self.dicMonitorDelivery.value(forKey: "R") ?? "0.0")"
        let strTemp = "\(self.dicMonitorDelivery.value(forKey: "T(K)") ?? "0.0")"
        let strPressure = "\(self.dicMonitorDelivery.value(forKey: "P(psig)") ?? "0.0")"
        
        
        self.lblDeliveryValue.text = "\(self.dicMonitorDelivery.value(forKey: "T") ?? "-")"
        self.lblDeliveryUnit.text = "\(self.strDeliveryUnit.lowercased())"
        self.arrDeliveryParametersValues.replaceObject(at: 2, with: "\(self.dicMonitorDelivery.value(forKey: "GT") ?? "-")")
        
        self.tblDeliveryTicket.reloadData()
        
        self.lblFlowRateValue.text = "\(strFlowRate) \n \(strDeliveryUnit)/min"
        
        self.lblTempratureValue.text = "\(strTemp) \n\(self.dicMonitorDelivery.value(forKey: "tUnit") ?? "")"
        
        self.lblPressureValue.text = "\(strPressure) \n\(self.dicMonitorDelivery.value(forKey: "pUnit") ?? "")"
    
    }
	
	
	@IBAction func btnBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
    
    //MARK:- User Define Methods.
    @objc func stopUpdating() {
        ICEManagerVC.shared.send_DELIVERY_STOP_Commands { (strResult) in
            if strResult != "" {
            
            }else{
            
            }
        }
    }
    
    @objc func stopUpdatingForUSCommand() {
        ICEManagerVC.shared.send_DELIVERY_STOP_Commands { (strResult) in
            if strResult != "" {
                
            }else{
                
            }
            self.send_US_CommandData()
        }
    }
    
    //MARK:- UITableView Delegates and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDeliveryParameters.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTicketCell", for: indexPath) as! DeliveryTicketCell
        cell.lblParameter.text = "\(self.arrDeliveryParameters[indexPath.row])"
        cell.lblValue.text = "\(self.arrDeliveryParametersValues[indexPath.row])"
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height)/CGFloat(arrDeliveryParametersValues.count)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    // MARK: - IBActions
    @IBAction func btnBluetoothConnectionPressed(_ sender: UIButton) {
        
    }
    
    //MARK:- View  END Life Cycle.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopUpdatingForUSCommand), object: nil)
        ICEManagerVC.shared.send_DELIVERY_STOP_Commands { (strResult) in
            
        }
    }

}
