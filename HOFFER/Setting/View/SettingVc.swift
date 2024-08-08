//
//  SettingVc.swift
//  HOFFER
//
//  Created by JAM-E-221 on 01/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit
import SVProgressHUD

class SettingVc: UIViewController {

    //MARK: IBOutlates
    
    @IBOutlet weak var settingTableView: UITableView!
    
    //MARK: properties
    
    var titleArr = [String()]
    var placeholderArr = ["First Name","Last Name","Email Address"]
    var btnPlaceholderArr = ["UPDATE PROFILE","CHANGE PASSWORD","LOGOUT","DELETE ACCOUNT"]
    var viewModel = SettingViewModel()
    
    //MARK: View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.observe()
        self.configureViews()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork(){
            self.viewModel.getUserProfile()
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
        }
    }
    
    
    func configureViews(){
        
        settingTableView.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        settingTableView.register(UINib( nibName:"ButtonCell",bundle: nil), forCellReuseIdentifier: "ButtonCell")
        settingTableView.separatorStyle = .none
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        self.titleArr.append("test")
        self.titleArr.append("\(UserDefaults.userId)")
        self.titleArr.append(UserDefaults.userEmail)
        
        
     
    }
   
    func observe() {
        
        self.viewModel.eventHandler = { event in
            switch event {
            case .loading:
                SVProgressHUD.show()
            case .stopLoading:
                print("dataLoaded")
            case .dataLoaded:
                self.success()
                SVProgressHUD.dismiss()
            case .error(let error):
                print(error as Any)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    
    func success() {
        if viewModel.requestType == "userProfile" {
            let dict = viewModel.userProfileDict
            DispatchQueue.main.async(){
                if dict.code == "0" {
                    self.settingTableView.reloadData()
                }else{
                    
                    Utilities.sharedInstance.showToast(source: self, message: dict.message ?? "")
                    
                }
            }
        }else{
            
            //TODO: - handel condition when token expired.
            
            if self.viewModel.requestType == "logout"{
                let dict = viewModel.settingResponceDict
                DispatchQueue.main.async(){
                    if dict.code == "0" {
                        UserDefaults.password =  ""
                        UserDefaults.userName =  ""
                        UserDefaults.userId = 0
                        UserDefaults.userEmail = ""
                        UserDefaults.accessToken = ""
                        Utilities.sharedInstance.showToast(source: self, message: dict.message)
                   
                        let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewViewController") as? LoginViewViewController
                   
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                    }else{
                        
                        Utilities.sharedInstance.showToast(source: self, message: dict.message)
                        
                    }
                }
            }else {
                let dict = viewModel.deleteResponceDict
                DispatchQueue.main.async(){
                    if dict.code == "0" {
                        UserDefaults.password =  ""
                        UserDefaults.userName =  ""
                        UserDefaults.userId = 0
                        UserDefaults.userEmail = ""
                        UserDefaults.accessToken = ""
                        Utilities.sharedInstance.showToast(source: self, message: dict.message)
                   
                        let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewViewController") as? LoginViewViewController
                   
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                    }else{
                        
                        Utilities.sharedInstance.showToast(source: self, message: dict.message)
                        
                    }
                }
            }
        }
       
        
       
    }
    @IBAction func didTabBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didtapLogout(){
        if Reachability.isConnectedToNetwork(){
            self.viewModel.logout()
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
        }
        
    }
    
   func didtapChangePassword(){
        let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordVc") as? ChangePasswordVc
        self.navigationController?.pushViewController(vc!, animated: false)
    }
   func didtapDeleteAccount(){
        self.showAlert()
    }
    
    
    
    
    //???: when user taped on btn.
    
    @objc func didtapButton(_ sender:UIButton){
        print(sender.tag)
        if sender.tag == 0{
            print("update Profile")
            let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileViewController") as?
            ProfileViewController
            vc?.firstName = self.viewModel.userProfileDict.data?.first_name ?? ""
            vc?.lastName = self.viewModel.userProfileDict.data?.last_name ?? ""
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if sender.tag == 1{
            print("Change Password")
            self.didtapChangePassword()
        }
        else if sender.tag == 2{
            print("LogOUT")
            self.didtapLogout()
        }
        else if sender.tag == 3{
            print("Delete Account")
            self.didtapDeleteAccount()
        }
        
    }
    
    //!!!:  Function to delete Account for show the alert.
    
    func showAlert() {
        let alertController = UIAlertController(title: "Alert", message: "Do You want to Delete Account ?", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            
            print("Done button tapped")
          if Reachability.isConnectedToNetwork(){
              self.viewModel.deleteAccount()
          }else{
              Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
          }
        }
        doneAction.setValue(UIColor.red, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // Handle "Cancel" button action
            print("Cancel button tapped")
            
          
        }
        
        cancelAction.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
}



//MARK: - Extension TableView Delegates and DataSoures.


extension SettingVc:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else{
            return 4
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTableViewCell", for: indexPath) as! AuthTableViewCell
            
            cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText:  titleArr[indexPath.row])
            cell.textFieldOutlet.setLeftPaddingPoints(10)
            cell.textFieldOutlet.setRightPaddingPoints(10)
         cell.istyping = false
            cell.emailLabel.text = placeholderArr[indexPath.row]
            cell.eyeBtn.isHidden = true
            cell.selectionStyle = .none
            
            if indexPath.row == 0 {
                cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText: self.viewModel.userProfileDict.data?.first_name ?? "" )
            }else if indexPath.row == 1{
                cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText: self.viewModel.userProfileDict.data?.last_name ?? "" )
               
            }else{
                cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText: self.viewModel.userProfileDict.data?.email ?? "" )
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.btnOlt.setTitle(self.btnPlaceholderArr[indexPath
                .row], for: .normal)
            cell.btnOlt.addTarget(self, action: #selector(didtapButton), for: .touchUpInside)
            cell.btnOlt.tag = indexPath.row
            
            if indexPath.row != 3{
                cell.btnOlt.backgroundColor = UIColor(hex: "#203E84")
            } else {
                cell.btnOlt.backgroundColor = .systemRed
            }
            cell.selectionStyle = .none
            return cell
        }
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 105
        }else{
            return 70
        }
    }
    
    
}


extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
