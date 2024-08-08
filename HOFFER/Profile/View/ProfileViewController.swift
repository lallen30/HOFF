//
//  ProfileViewController.swift
//  HOFFER
//
//  Created by JAM-E-221 on 02/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    //MARK: IBOutlates
    
    @IBOutlet weak var profileTableView: UITableView!
    
    //MARK: properties
    
    var titleArr = [String()]
    var placeholderArr = ["First Name","Last Name","Email Address"]
    var firstName = ""
    var lastName = ""
    var viewModel = ProfileViewModel()
    
    //MARK: View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observe()
        self.configureViews()
        
    }
    
    func configureViews(){
        
        
        profileTableView.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        profileTableView.register(UINib( nibName:"ButtonCell",bundle: nil), forCellReuseIdentifier: "ButtonCell")
        profileTableView.separatorStyle = .none
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        
        
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
        let dict = viewModel.profileresponseDict
        DispatchQueue.main.async(){
            if dict.code == "0" {
                Utilities.sharedInstance.showToast(source: self, message: dict.message ?? "")
                self.navigationController?.popViewController(animated: true)
                
            }else{
                
                Utilities.sharedInstance.showToast(source: self, message: dict.message ?? "")
                
            }
        }
        
        
        
    }
    @IBAction func didTabBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func didtapButton(_ sender:UIButton){
        print(sender.tag)
        if sender.tag == 0{
            print("update Profile")
            self.showAlert()
        }
        
    }
    
    
    func textFieldEnds(indexPath:IndexPath, textField:UITextField){
        if indexPath.row == 0{
            self.firstName = textField.text ?? ""
            print(firstName)
        }else if indexPath.row == 1{
            self.lastName = textField.text ?? ""
            print(lastName)
        }
    }
    
    
    func didtapSubmit(){
        print("didtapSubmit")
        self.view.endEditing(true)
        if self.firstName == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter  First Name")
        }else if self.lastName == ""{
            Utilities.sharedInstance.showToast(source: self, message: "Please Enter Last Name")
        }
        else{
            self.viewModel.updateProfile(param: ProfileUpdateRequest(first_name: self.firstName, last_name: self.lastName))
        }
    }
    
    
    
    //MARK:  Function to show the alert
    
    func showAlert() {
        let alertController = UIAlertController(title: "Alert", message: "Do You want to update profile details ?", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            
            print("Done button tapped")
            if Reachability.isConnectedToNetwork(){
                
                self.didtapSubmit()
            }else{
                Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
            }
        }
        doneAction.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // Handle "Cancel" button action
            print("Cancel button tapped")
            
            
        }
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
}



//MARK: - Extension TableView Delegates and DataSoures.


extension ProfileViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthTableViewCell", for: indexPath) as! AuthTableViewCell
            
            cell.textFieldOutlet.setLeftPaddingPoints(10)
            cell.textFieldOutlet.setRightPaddingPoints(10)
            cell.emailLabel.text = placeholderArr[indexPath.row]
            cell.eyeBtn.isHidden = true
            cell.textFieldEditingEnds = { textField in
                self.textFieldEnds(indexPath: indexPath, textField: textField)
            }
            cell.selectionStyle = .none
            if indexPath.row == 0 {
//                cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText: self.firstName )
                cell.textFieldOutlet.text = self.firstName
            }else if indexPath.row == 1{
//                cell.textFieldOutlet.addPlaceHolder(color: .gray, placeholderText: self.lastName )
                cell.textFieldOutlet.text = self.lastName
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.btnOlt.setTitle("SUBMIT", for: .normal)
            cell.btnOlt.addTarget(self, action: #selector(didtapButton), for: .touchUpInside)
            cell.btnOlt.tag = indexPath.row
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

