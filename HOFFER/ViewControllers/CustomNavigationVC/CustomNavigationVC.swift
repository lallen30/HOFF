//
//  CustomNavigationVC.swift
//  HOFFER
//
//  Created by SiliconMac on 06/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class CustomNavigationVC: UINavigationController, UINavigationControllerDelegate {

    //MARK: - IBOutlet & Variables
    public var isOffline = false
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationBar.barTintColor = #colorLiteral(red: 0.1254901961, green: 0.2431372549, blue: 0.5176470588, alpha: 1)
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom Methods
    func setBluetoothConnectivityButtonInNavBar(VC : UIViewController) -> Void {
        let btnBT : UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "bluetoothConnect"), style: .done, target: self, action: #selector(btnBluetoothPressed))
        //btnBT.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        btnBT.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        VC.navigationItem.rightBarButtonItems = [btnBT]
        
    }
    
    func setTwoButtonInNavBar(VC : DashboardVC) -> Void {
        /*let btnBT : UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "bluetoothConnect"), style: .done, target: self, action: #selector(btnBluetoothPressed))
        btnBT.imageInsets = UIEdgeInsetsMake(0, 0,-10, 0)
        btnBT.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let btnEdit : UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "edit-icon"), style: .done, target: self, action: #selector(didTapHeader))
        btnEdit.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnEdit.imageInsets = UIEdgeInsetsMake(0, 0, 0,-10)*/
        
		let searchBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
		searchBtn.setImage(#imageLiteral(resourceName: "bluetoothConnect"), for: UIControl.State.normal)
		searchBtn.addTarget(self, action: #selector(btnBluetoothPressed), for: UIControl.Event.touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        
        if isOffline {
            VC.navigationItem.rightBarButtonItems = [searchBarBtn]
        }else{
			let btnEdit : UIButton = UIButton(type: UIButton.ButtonType.custom)
			btnEdit.setImage(#imageLiteral(resourceName: "edit-icon"), for: UIControl.State.normal)
			btnEdit.addTarget(self, action: #selector(didTapHeader), for: UIControl.Event.touchUpInside)
            btnEdit.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            let btnEditBar = UIBarButtonItem(customView: btnEdit)
            
            VC.navigationItem.rightBarButtonItems = [searchBarBtn,btnEditBar]
        }
        
        
        
        
        
        /*let clipBtn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        clipBtn.setImage(clipImage, forState: UIControlState.Normal)
        clipBtn.addTarget(self, action: "clipBtnPressed", forControlEvents: UIControlEvents.TouchUpInside)
        clipBtn.frame = CGRectMake(0, 0, 30, 30)
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)*/
        
    }
    
    // MARK: - Navigation Delegate Methods
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("didShow" + "\(viewController)")
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("willShow" + "\(viewController)")
        
        if viewController.isKind(of: StartUpVC.self) || viewController.isKind(of: LoginVC.self)
        {
            viewController.navigationController?.navigationBar.isHidden = true
        }
        
        if viewController.isKind(of: SearchBluetoothVC.self) || viewController.isKind(of: ForgotPasswordVC.self) || viewController.isKind(of: TripReportVC.self) || viewController.isKind(of: Audit_TrailVC.self) {
            
        }
        else if viewController.isKind(of: DashboardVC.self){
            self.setTwoButtonInNavBar(VC: viewController as! DashboardVC)
        }
        else
        {
            self.setBluetoothConnectivityButtonInNavBar(VC: viewController)
        }        
    }
    
    // MARK: - IBAction
    @objc func btnBluetoothPressed() -> Void {
        
    }
    
    @objc func didTapHeader() -> Void {
        NotificationCenter.default.post(name: Notification.Name("NotificationEditClick"), object: nil)
    }
}
