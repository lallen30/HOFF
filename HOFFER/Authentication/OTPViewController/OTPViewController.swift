//
//  OTPViewController.swift
//  HOFFER
//
//  Created by JAM-E-214 on 24/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit
import SVProgressHUD

class OTPViewController: UIViewController {
    
    //MARK: IBOutlates
    
    @IBOutlet weak var codeTextTableView: UITableView!
    @IBOutlet weak var sendAgainBtnOlt: UIButton!
    @IBOutlet weak var submitBtnOlt: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var exitBtnOlt: UIButton!
    
    //MARK: properties
    
    var placeholder = ""
    var otpCode = ""
    var comeFrom  = ""
    var otp = ""
    var email = ""
    var viewModel = ForgotViewModel()
    var isLoading: Bool = false
    
    //MARK: view life Cycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialSetup()
            
        
    }
    
    //MARK: - Configuration Methods
    
    func loadInitialSetup(){
        configureViews()
    }
    func configureViews(){
        observe()
        codeTextTableView.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        codeTextTableView.separatorStyle = .none
        codeTextTableView.delegate = self
        codeTextTableView.dataSource = self
        submitBtnOlt.dropShadow(opacity: 1, shadowRadius: 0.5, cornerRadius: 8, shadowColor: .blue)
        sendAgainBtnOlt.dropShadow(opacity: 0.5, shadowRadius: 2, cornerRadius: 8, shadowColor: .black)
        exitBtnOlt.dropShadow(opacity: 0.5, shadowRadius: 2, cornerRadius: 8, shadowColor: .black)
        exitBtnOlt.isHidden = true
        let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        if comeFrom == "SuccessEmail"{
            textLabel.text = "Success! Please enter the code that was sent to the email associated with your account."
            sendAgainBtnOlt.setTitle("SEND AGAIN", for: .normal)
            placeholder = "Enter Code"
        }else{
            textLabel.text = "The email address you entered is not associated with an account. Please try again with a different email."
            sendAgainBtnOlt.setTitle("EXIT", for: .normal)
            placeholder = "Enter Email"
        }
        
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    //MARK: - Closures
    
    func textFieldEnds(indexPath:IndexPath, textField:UITextField){
        if indexPath.row == 0{
            self.otpCode = textField.text ?? ""
            
            
        }
    }
    
    //MARK: IBActions
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if otpCode == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Incorrect Code")
            
        }else if otpCode == otp{
            let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateNewPasswordViewController") as? CreateNewPasswordViewController
            vc?.email = email
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Incorrect OTP")
            textLabel.text = "The code you entered was not correct, please try again."
            placeholder = "Enter Code"
            sendAgainBtnOlt.isHidden = true
            exitBtnOlt.isHidden = false
        }
    }
    
    @IBAction func exitBtnAction(_ sender: UIButton) {
        
    }
    @IBAction func sendAgainBtnAction(_ sender: UIButton) {
        viewModel.forgot(parameters: ForgotRequest(email: email))
        
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
        
        DispatchQueue.main.sync(){
            if dict.code == "0"{
                otp = dict.otp ?? ""
            }else{
                Utilities.sharedInstance.showToast(source: self, message: dict.message ?? "")
            }
            
        }
        
    }
}

//MARK: - TableVIew Delegates and Datasources

extension OTPViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTableViewCell", for: indexPath) as! AuthTableViewCell
        
        cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText:  placeholder)
        cell.textFieldOutlet.setLeftPaddingPoints(10)
        cell.textFieldOutlet.setRightPaddingPoints(10)
        if comeFrom == "SuccessEmail"{
            cell.emailLabel.text = "Code"
        }else{
            cell.emailLabel.text = "Email:"
        }
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
