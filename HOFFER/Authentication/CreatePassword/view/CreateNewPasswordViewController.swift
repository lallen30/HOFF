//
//  CreateNewPasswordViewController.swift
//  HOFFER
//
//  Created by JAM-E-214 on 24/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateNewPasswordViewController: UIViewController {
    
    //MARK: IBOutlates
    
    @IBOutlet weak var submitBtiOlt: UIButton!
    @IBOutlet weak var creatNewTextTavleView: UITableView!
    
    //MARK: Properties
    
    var placeholderArr = ["New Password", "Confirm Password"]
    var email = ""
    var passwors = ""
    var confirmPassword = ""
    var isLoading: Bool = false
    var viewModel = updatePasswordViewModel()
    
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
        submitBtiOlt.layer.borderColor = UIColor.gray.cgColor
        submitBtiOlt.layer.cornerRadius = 8
        submitBtiOlt.layer.borderWidth = 0.5
        creatNewTextTavleView.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        creatNewTextTavleView.separatorStyle = .none
        creatNewTextTavleView.delegate = self
        creatNewTextTavleView.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: IBAction
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if passwors == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Password")
        }else if confirmPassword == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter ConfirmPassword")
        }else if passwors != confirmPassword {
            Utilities.sharedInstance.showToast(source: self, message: "Password and ConfirmPassword should be Same")
        }else if Reachability.isConnectedToNetwork(){
            viewModel.updatePassword(parameters: updatePasswordRequest(email: email, password: passwors))
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
        }
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Closures
    
    func textFieldEnds(indexPath:IndexPath, textField:UITextField){
        if indexPath.row == 0{
            self.passwors = textField.text ?? ""
            print(passwors)
        }else if indexPath.row == 1{
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
        let dict = viewModel.updatePasswordResponceDict
        if dict.code == "0"{
            DispatchQueue.main.async(){
                let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController
                vc?.dismissPop = {
                    self.dismiss(animated: true)
                    let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewViewController") as? LoginViewViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                }
                
                self.present(vc!, animated: true)
            }
        }else{
            
            Utilities.sharedInstance.showToast(source: self, message: dict.message)
            
        }
        
    }
    
}
//MARK: - TableView Delegates and DataSources.

extension CreateNewPasswordViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    
}
