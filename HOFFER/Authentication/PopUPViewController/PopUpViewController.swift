//
//  PopUpViewController.swift
//  HOFFER
//
//  Created by JAM-E-214 on 24/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    //MARK: IBOutlates
    
    @IBOutlet weak var loginBtnOlt: UIButton!
    
    //MARK: Properties
    
    var dismissPop : () -> () = { }
    
    //MARK: View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialSetup()
       
    }
    
    //MARK: - Configuration Methods
    
    func loadInitialSetup(){
        configureViews()
    }
    
    func configureViews(){
        loginBtnOlt.layer.borderColor = UIColor.gray.cgColor
        loginBtnOlt.layer.cornerRadius = 10
        loginBtnOlt.layer.borderWidth = 0.5
        
    }
    @IBAction func loginBtnAction(_ sender: UIButton) {
    
        dismissPop()
    }
    

   

}
