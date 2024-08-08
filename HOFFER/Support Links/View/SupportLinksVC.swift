//
//  SupportLinksVC.swift
//  HOFFER
//
//  Created by JAM-E-221 on 03/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit
import SVProgressHUD

class SupportLinksVC: UIViewController {
    
    //MARK: IBOutlates
    
    @IBOutlet weak var supportTableView: UITableView!
    
    //MARK: properties
    
    
    var placeholderArr = ["First Name","Last Name","Email Address"]
    var btnPlaceholderArr = ["UPDATE PROFILE","CHANGE PASSWORD","LOGOUT","DELETE ACCOUNT"]
    var viewModel = SupportLinksVM()
    
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
            
            //TODO: - Add api for get links .
            
            //            self.viewModel.getSupportlinks()
        }else{
            Utilities.sharedInstance.showToast(source: self, message: "Please check your internet connection")
        }
    }
    
    
    func configureViews(){
        
        supportTableView.register(UINib( nibName:"AuthTableViewCell",bundle: nil), forCellReuseIdentifier: "AuthTableViewCell")
        supportTableView.register(UINib( nibName:"SupportCell",bundle: nil), forCellReuseIdentifier: "SupportCell")
        supportTableView.separatorStyle = .none
        supportTableView.delegate = self
        supportTableView.dataSource = self
        
        self.supportTableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        
        
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
        let dict = viewModel.supportLinksDict
        DispatchQueue.main.async(){
            if dict.code == "0" {
                self.supportTableView.reloadData()
            }else{
                
                Utilities.sharedInstance.showToast(source: self, message: dict.message)
                
            }
        }
        
        
    }
    
    
    @IBAction func didTabBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}



//MARK: - Extension TableView Delegates and DataSoures.


extension SupportLinksVC:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else{
            return 2
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportCell", for: indexPath) as! SupportCell
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.linkLabel.text = "Example Link Name"
        }else{
            cell.linkLabel.text = "External Links Name"
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        view.bottomView.layer.cornerRadius = 2
        if section == 0 {
            view.labelOlt.text = "Support Links"
        }else{
            view.labelOlt.text = "External Links"
            
        }
        return view
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}

