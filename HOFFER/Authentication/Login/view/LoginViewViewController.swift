//
//  LoginViewViewController.swift
//  HOFFER
//
//  Created by JAM-E-214 on 23/04/24.
//  Copyright © 2024 JAME 255. All rights reserved.
//

import UIKit
import SVProgressHUD


class LoginViewViewController: UIViewController {
    
    // MARK: IBoutlates
    
    @IBOutlet weak var rememberMeBtn: UIButton!
    @IBOutlet weak var sigInBtn: UIButton!
    @IBOutlet weak var authTableView: UITableView!
    
    
    // MARK: properties
    
    var placeholderArr = ["Enter Email", "Enter Password"]
    var email = ""
    var password = ""
    var isRememberMeClicked = false
    var viewModel = LoginViewModel()
    var isLoading: Bool = false
    
    // MARK: view life cycle method
    
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
        UserDefaults.stayLoggedIn = true
        self.isRememberMeClicked = UserDefaults.stayLoggedIn
        sigInBtn.layer.borderColor = UIColor.gray.cgColor
        sigInBtn.layer.cornerRadius = 8
        sigInBtn.layer.borderWidth = 0.5
        authTableView.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        authTableView.separatorStyle = .none
        authTableView.delegate = self
        authTableView.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              view.addGestureRecognizer(tapGesture)
    }
    
    
    //MARK: - Closures
    
    func textFieldEnds(indexPath:IndexPath, textField:UITextField){
        if indexPath.row == 0{
            self.email = textField.text ?? ""
            print(email)
        }else if indexPath.row == 1{
            self.password = textField.text ?? ""
            print(password)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func signInBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if !Utilities.isValidEmail(email){
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter valid Email")
        }else if email == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Email")
        }else if password == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Password")
        }else if Reachability.isConnectedToNetwork(){
            viewModel.logIn(parameters: LoginRequest(email: email, password: password))
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
        vc?.email = email
        self.navigationController?.pushViewController(vc!, animated: true)
        
//        let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
//       
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func createAccountBtnAction(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateAccountViewController") as? CreateAccountViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func rememberMeBtnAction(_ sender: UIButton) {
        if isRememberMeClicked{
            isRememberMeClicked = false
            UserDefaults.stayLoggedIn = false
            rememberMeBtn.setImage(UIImage(systemName: "app"), for: .normal)
        }else{
            isRememberMeClicked = true
            UserDefaults.stayLoggedIn = true
            rememberMeBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
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
        let dict = viewModel.loginResponceDict
        DispatchQueue.main.async(){
            if dict.message == "Success" {
                UserDefaults.password =  self.password
                UserDefaults.userName = dict.data?.username ?? ""
                UserDefaults.userId = dict.data?.id ?? 0
                UserDefaults.userEmail = dict.data?.email ?? ""
                UserDefaults.accessToken = dict.token ?? ""
                
                Utilities.sharedInstance.showToast(source: self, message: dict.message)
                print(UserDefaults.userId)
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchBluetoothVC") as? SearchBluetoothVC
                self.navigationController?.pushViewController(vc!, animated: false)
                
            }else{
                
                Utilities.sharedInstance.showToast(source: self, message: dict.message)
                
            }
        }
    }
    
    
    
    
}

//MARK: - Extension

extension LoginViewViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTableViewCell", for: indexPath) as! AuthTableViewCell
        
        cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText:  placeholderArr[indexPath.row])
        cell.textFieldOutlet.setLeftPaddingPoints(10)
        if indexPath.row == 0{
            cell.emailLabel.text = "Email:"
            cell.eyeBtn.isHidden = true
            cell.textFieldOutlet.isSecureTextEntry = false
            cell.textFieldOutlet.setRightPaddingPoints(10)
        }else{
            cell.emailLabel.text = "Password:"
            cell.eyeBtn.isHidden = false
            cell.textFieldOutlet.isSecureTextEntry = true
            cell.textFieldOutlet.setRightPaddingPoints(50)
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

