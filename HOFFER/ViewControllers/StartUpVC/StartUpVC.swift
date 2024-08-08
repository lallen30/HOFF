//
//  StartUpVC.swift
//  HOFFER
//
//  Created by Admin on 07/09/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class StartUpVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singleton.sharedSingleton.getDevicesList(successBlock: {
            print("Success")
        }) {
            print("Failier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isUserLogin
        {
            self.performSegue(withIdentifier: "segToSearchBtVC", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "segToLoginVC", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
