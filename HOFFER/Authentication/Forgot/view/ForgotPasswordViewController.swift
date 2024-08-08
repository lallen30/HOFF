//
//  ForgotPasswordViewController.swift
//  HOFFER
//
//  Created by JAM-E-214 on 23/04/24.
//  Copyright © 2024 JAME255 . All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {
    
    //MARK: IBOutlates
    
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var exitBtnOlt: UIButton!
    @IBOutlet weak var forgotTextTableView: UITableView!
    @IBOutlet weak var submitBtnOlt: UIButton!
    
    //MARK: properties
    
    var placeholderArr = ["Email"]
    var email = ""
    var viewModel = ForgotViewModel()
    var isLoading: Bool = false
    var comeFrom = "login"
    
    // MARK: View life cycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInitialSetup()
        
        if comeFrom == "login"{
            titleOutlet.text = "Please enter the email associated with your account !"
        }else{
            titleOutlet.text = "Success! Please enter the code that was sent to the email associated with your account"
        }
    }
    
    //MARK: - Configuration Methods
    
    func loadInitialSetup(){
        configureViews()
        observe()
    }
    
    
    func configureViews(){
        
        forgotTextTableView.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        forgotTextTableView.separatorStyle = .none
        forgotTextTableView.delegate = self
        forgotTextTableView.dataSource = self
        submitBtnOlt.layer.borderColor = UIColor.gray.cgColor
        submitBtnOlt.layer.cornerRadius = 8
        submitBtnOlt.layer.borderWidth = 0.5
        exitBtnOlt.isHidden = true
        exitBtnOlt.dropShadow(opacity: 0.5, shadowRadius: 2, cornerRadius: 10, shadowColor: .black)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    //MARK: - Closures
    
    func textFieldEnds(indexPath:IndexPath, textField:UITextField){
        if indexPath.row == 0{
            self.email = textField.text ?? ""
            print(email)
            
        }
    }
    
    
    //MARK: IBActions
    @IBAction func exitBtnAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if email == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Email")
        }else if Reachability.isConnectedToNetwork(){
            viewModel.forgot(parameters: ForgotRequest(email: email))
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
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
                SVProgressHUD.dismiss()
                self.success()
            case .error(let error):
                print(error as Any)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func success() {
        let dict = viewModel.forgotResponceDict
        
        DispatchQueue.main.async(){
            if dict.code == "0"{
                let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
                vc?.comeFrom = "SuccessEmail"
                vc?.otp = dict.otp ?? ""
                vc?.email = self.email
                self.navigationController?.pushViewController(vc!, animated: false)
                
            }else if dict.code == "2"{
                self.titleOutlet.text = "The email you entered was not correct, please try again."
                self.exitBtnOlt.isHidden = false
                Utilities.sharedInstance.showToast(source: self, message: dict.message ?? "")
            }else{
                Utilities.sharedInstance.showToast(source: self, message: dict.message ?? "")
            }
            
        }
        
    }
    
}

//MARK: - Extension TableView Delegates and DataSoures.


extension ForgotPasswordViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTableViewCell", for: indexPath) as! AuthTableViewCell
        
        cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText:  placeholderArr[indexPath.row])
        cell.textFieldOutlet.setLeftPaddingPoints(10)
        cell.textFieldOutlet.setRightPaddingPoints(10)
        cell.textFieldOutlet.text = email
        cell.emailLabel.text = "Email:"
        cell.eyeBtn.isHidden = true
        
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
