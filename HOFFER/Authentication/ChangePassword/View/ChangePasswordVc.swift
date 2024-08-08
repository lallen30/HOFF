//
//  ChangePasswordVc.swift
//  HOFFER
//
//  Created by JAM-E-221 on 02/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordVc: UIViewController {
    
    
    //MARK: IBOutlates
    
    @IBOutlet weak var submitBtiOlt: UIButton!
    @IBOutlet weak var changePassword: UITableView!
    
    //MARK: Properties
    
    var placeholderArr = ["Old Password","New Password", "Confirm Password" ]
    var email = ""
    var passwors = ""
    var oldPassword = ""
    var confirmPassword = ""
    var isLoading: Bool = false
    var viewModel = ChangeViewModel()
    
    //MARK: View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialSetup()
        print(email)
    }
    
    //MARK: - Configuration Methods
    
    func loadInitialSetup(){
        configureViews()
        observe()
    }
    func configureViews(){
        changePassword.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        changePassword.register(UINib( nibName:"ButtonCell",bundle: nil), forCellReuseIdentifier: "ButtonCell")
        changePassword.separatorStyle = .none
        changePassword.delegate = self
        changePassword.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: IBAction
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Closures
    
    func textFieldEnds(indexPath:IndexPath, textField:UITextField){
        if indexPath.row == 0{
            self.oldPassword = textField.text ?? ""
            print(oldPassword)
        }else if indexPath.row == 1{
            self.passwors = textField.text ?? ""
            print(passwors)
        }else if indexPath.row == 2{
            self.confirmPassword = textField.text ?? ""
            print(confirmPassword)
        }
    }
    
    func observe() {
        
        self.viewModel.eventHandler = { event in
            switch event {
            case .loading:
                SVProgressHUD.show()
                self.isLoading = true
            case .stopLoading:
                self.isLoading = false
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
        let dict = viewModel.responseDict
        if dict.code == "0"{
            DispatchQueue.main.async(){
                Utilities.sharedInstance.showToast(source: self, message: dict.message)
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            DispatchQueue.main.async(){
                Utilities.sharedInstance.showToast(source: self, message: dict.message)
            }
        }
        
    }
    
    
    @objc func didtapSubmit(){
      print("didtapSubmit")
        self.view.endEditing(true)
        if oldPassword == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Old Password")
        }else if passwors == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Password")
        }else if confirmPassword == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter ConfirmPassword")
        }else if passwors != confirmPassword {
            Utilities.sharedInstance.showToast(source: self, message: "Password and ConfirmPassword should be Same")
        }else if Reachability.isConnectedToNetwork(){
            viewModel.changePaswword(param: ChangePasswordRequest(old_password: self.oldPassword, new_password: self.confirmPassword))
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
        }
    }
    
}
//MARK: - TableView Delegates and DataSources.

extension ChangePasswordVc:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }else {
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTableViewCell", for: indexPath) as! AuthTableViewCell
            
            cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText:  placeholderArr[indexPath.row])
            cell.textFieldOutlet.setLeftPaddingPoints(10)
            cell.textFieldOutlet.setRightPaddingPoints(50)
            cell.emailLabel.text = placeholderArr[indexPath.row]
            cell.eyeBtn.isHidden = false
            cell.textFieldOutlet.isSecureTextEntry = true
            cell.textFieldEditingEnds = { textField in
                self.textFieldEnds(indexPath: indexPath, textField: textField)
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.btnOlt.setTitle("SUBMIT", for: .normal)
         
                cell.btnOlt.addTarget(self, action: #selector(didtapSubmit), for: .touchUpInside)
      
        
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    
}
