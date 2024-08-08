//
//  HomeViewController.swift
//  HOFFER
//
//  Created by JAM-E-214 on 29/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit
import SVProgressHUD
class HomeViewController: UIViewController {

    // MARK: IBoutlates
    
    @IBOutlet weak var disconnectBtnOlt: UIButton!
    @IBOutlet weak var homeTableView: UITableView!
	@IBOutlet weak var btStatusLbl: UILabel!
	@IBOutlet weak var disconnectBtnHeight: NSLayoutConstraint!
	
	
    // MARK: properties
    
    var dataArr = ["Delivery Ticket", "Saved Tickets", "Trip Report", "Audit Trail", "Monitor Delivery", "Configuration", "Support Links"]
    var imageArr = ["DeliveryTicket", "savedTicket", "tripReport", "audit", "monitor", "config", "print"]
	var comeFrom = ""
    
    //MARK: View life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialSetup()
        
    }
    
    //MARK: - Configuration Methods
    
    func loadInitialSetup(){
        configureViews()
        
    }
    
    
    func configureViews(){
		if APPDELEGATE.isBTOffline{
			btStatusLbl.text = "OFFLINE"
			self.disconnectBtnOlt.isHidden = true
			disconnectBtnHeight.constant = 0
		}else{
			btStatusLbl.text = "ONLINE"
			self.disconnectBtnOlt.isHidden = false
			disconnectBtnHeight.constant = 55
		}
        self.navigationController?.navigationBar.isHidden = true
        disconnectBtnOlt.dropShadow(opacity: 0.5, shadowRadius: 0, cornerRadius: 10, shadowColor: .black)
        homeTableView.register(UINib( nibName:"HomeCell",bundle: nil), forCellReuseIdentifier: "HomeCell")
        homeTableView.separatorStyle = .none
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    
    @IBAction func didtapSetting(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingVc") as? SettingVc
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func disconnectBtnAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
    }
	
	@IBAction func didTapBluetoothBtn(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func didTapEditBtn(_ sender: UIButton) {
	}
	
    
}

//MARK: - TableView delegates and dataSources.

extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.titleLabel.text = dataArr[indexPath.row]
        cell.titleImage.image = UIImage(named: imageArr[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
			if APPDELEGATE.isBTOffline{
				Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "This option is not available for offline.")
			}else{
				let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeliveryTicketVC") as? DeliveryTicketVC
				self.navigationController?.pushViewController(vc!, animated: true)
			}

        }else if indexPath.row == 1{
			let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SavedTicketListVC") as? SavedTicketListVC
			self.navigationController?.pushViewController(vc!, animated: true)

        }else if indexPath.row == 2{
			if APPDELEGATE.isBTOffline{
				Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "This option is not available for offline.")
			}else{
				let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TripReportVC") as? TripReportVC
				self.navigationController?.pushViewController(vc!, animated: true)
			}
        }else if indexPath.row == 3{
			if APPDELEGATE.isBTOffline{
				Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "This option is not available for offline.")
			}else{
				let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Audit_TrailVC") as? Audit_TrailVC
				self.navigationController?.pushViewController(vc!, animated: true)
			}

        }else if indexPath.row == 4{
			if APPDELEGATE.isBTOffline{
				Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "This option is not available for offline.")
			}else{
				let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MonitorDeliveryVC") as? MonitorDeliveryVC?)!
				self.navigationController?.pushViewController(vc!, animated: true)
			}

		}else if indexPath.row == 5{
			if APPDELEGATE.isBTOffline{
				Singleton.sharedSingleton.showAlertWithSingleButton(strMessage: "This option is not available for offline.")
			}else{
				let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfigurationVC") as? ConfigurationVC?)!
				self.navigationController?.pushViewController(vc!, animated: true)
			}

		}else{
            let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "SupportLinksVC") as? SupportLinksVC
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
    
}



