//
//  CreateAccountViewController.swift
//  HOFFER
//
//  Created by JAM-E-214 on 24/04/24.
//  Copyright © 2024 JAME 255 . All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateAccountViewController: UIViewController {
    
    // MARK: IBOutlates
    
    @IBOutlet weak var createTextTableView: UITableView!
    @IBOutlet weak var submitBtnOlt: UIButton!
    
    // MARK: IBOutlates
    
    var placeholderArr = ["First Name", "Last Name", "Email Address", "Password", " Confirm Password"]
    var firstName = ""
    var lastName = ""
    var emailAddress = ""
    var password = ""
    var confirmPawrd = ""
    var viewModel = RegisterViewModel()
    var isLoading: Bool = false
    
    
    // MARK: View life cylce method.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialSetup()
        
    }
    
    
    //MARK: - Configuration Methods
    
    func loadInitialSetup(){
        configureViews()
        observe()
    }
    
    func configureViews(){
        createTextTableView.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        createTextTableView.separatorStyle = .none
        createTextTableView.delegate = self
        createTextTableView.dataSource = self
        submitBtnOlt.layer.borderColor = UIColor.gray.cgColor
        submitBtnOlt.layer.cornerRadius = 8
        submitBtnOlt.layer.borderWidth = 0.5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
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
        let dict = viewModel.registerResponceDict
        DispatchQueue.main.async(){
            if dict.message == "Success" {
                
                Utilities.sharedInstance.showToast(source: self, message: dict.message ?? "")
                
                self.navigationController?.popViewController(animated: true)
                
            }else{
                
                Utilities.sharedInstance.showToast(source: self, message: dict.message ?? "")
                
            }
        }
    }
    
    //MARK: - Closures
    
    func textFieldEnds(indexPath:IndexPath, textField:UITextField){
        if indexPath.row == 0{
            self.firstName = textField.text ?? ""
        }else if indexPath.row == 1{
            self.lastName = textField.text ?? ""
        }else if indexPath.row == 2{
            self.emailAddress = textField.text ?? ""
        }else if indexPath.row == 3{
            self.password = textField.text ?? ""
        }else if indexPath.row == 4{
            self.confirmPawrd = textField.text ?? ""
        }
    }
    
    // MARK: IBActions
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if firstName == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Name")
        }else if lastName == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Last Name")
        }else if emailAddress == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Email")
        }else if !Utilities.isValidEmail(emailAddress){
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter ValidEmail")
        }else if password == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Password")
        }else if confirmPawrd == "" {
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter ConfirmPawrd")
        }else if password != confirmPawrd{
            Utilities.sharedInstance.showToast(source: self, message: "Password and ConfirmPawrd should be Same")
        }else if Reachability.isConnectedToNetwork(){
            viewModel.registerUser(parameters: RegisterRequest(first_name: firstName, last_name: lastName, email: emailAddress, password: password, confirm_password: confirmPawrd))
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
        }
    }
    
    
    
}

//MARK: - TableView delegates and dataSources.

extension CreateAccountViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTableViewCell", for: indexPath) as! AuthTableViewCell
        
        cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText:  placeholderArr[indexPath.row])
        cell.textFieldOutlet.setLeftPaddingPoints(10)
        
        cell.emailLabel.text = placeholderArr[indexPath.row]
        if indexPath.row == 4{
            cell.eyeBtn.isHidden = false
            cell.textFieldOutlet.isSecureTextEntry = true
            cell.textFieldOutlet.setRightPaddingPoints(50)
        }else if indexPath.row == 3{
            cell.eyeBtn.isHidden = false
            cell.textFieldOutlet.isSecureTextEntry = true
            cell.textFieldOutlet.setRightPaddingPoints(50)
        }else{
            cell.eyeBtn.isHidden = true
            cell.textFieldOutlet.isSecureTextEntry = false
            cell.textFieldOutlet.setRightPaddingPoints(10)
        }
        cell.textFieldEditingEnds = { textField in
            self.textFieldEnds(indexPath: indexPath, textField: textField)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    
}
