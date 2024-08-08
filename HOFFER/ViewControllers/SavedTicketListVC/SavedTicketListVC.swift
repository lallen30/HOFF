//
//  SavedTicketListVC.swift
//  HOFFER
//
//  Created by Admin on 31/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class SavedTicketListVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var tblSavedTicketList: UITableView!
    @IBOutlet weak var lblNoTicketAvailable: UILabel!
    
    var arrSavedTickets = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.titleView?.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSavedTicketList()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //guard !FeatureFlags.isBypassForScreen else {
        //    self.performSegue(withIdentifier: "segToDeliveryTicketVC", sender: self.strOutPut)
        //    return
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- UITableView Delegates and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return Singleton.sharedSingleton.arrSavedTicket.count
        }else{
           return self.arrSavedTickets.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTicketListCell", for: indexPath) as! SavedTicketListCell
        if indexPath.section == 0 {
            let dic = Singleton.sharedSingleton.arrSavedTicket[indexPath.row]
            cell.lblTicketTitle.text = "Trailer No: \(dic.value(forKey: "trailer_number") ?? "-")"
            cell.lblDateTime.text = "\(dic.value(forKey: "time") ?? "-") \n \(dic.value(forKey: "date") ?? "-")"
            cell.viewRedDot.isHidden = false
        }else{
            let dic = self.arrSavedTickets.object(at: indexPath.row) as! NSDictionary
            cell.lblTicketTitle.text = "Trailer No: \(dic.value(forKey: "trailer_number") ?? "-")"
            cell.lblDateTime.text = "\(dic.value(forKey: "time") ?? "-") \n \(dic.value(forKey: "date") ?? "-")"
            cell.viewRedDot.isHidden = true
        }
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let dic = Singleton.sharedSingleton.arrSavedTicket[indexPath.row]
            self.performSegue(withIdentifier: "segToDeliveryTicketVC", sender: dic)
        }else{
            let dic = self.arrSavedTickets.object(at: indexPath.row) as! NSDictionary
            self.performSegue(withIdentifier: "segToDeliveryTicketVC", sender: dic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // MARK: - API Call for saved tickets.
    func getSavedTicketList() {
        
        let dicInput = NSMutableDictionary()
        //dicInput.setValue("\(dicUserDetail.value(forKey: "user_id") ?? "")", forKey: "user_id");
        let _ = AkWebServiceCall().CallApiWithPath(path: strApiSavedTicketList + "\(dicUserDetail.value(forKey: "user_id") ?? "0")", input: dicInput, showLoader: true, view: self.view, isGetMethod: false, isGetWithParameter: false, isPostWithGetParameters: false, success: { (dicResponse, isSuccess) in            
            print(dicResponse)
            self.arrSavedTickets.removeAllObjects()
            if isSuccess && dicResponse.value(forKey: "code") as! String == "0"
            {
                let arr = dicResponse.value(forKeyPath: "tickets") as? NSArray ?? NSArray()
                self.arrSavedTickets.addObjects(from: arr as! [Any])
                if arr.count > 0 || Singleton.sharedSingleton.arrSavedTicket.count > 0 {
                    self.lblNoTicketAvailable.isHidden = true
                } else {
                    self.lblNoTicketAvailable.isHidden = false
                }
                self.tblSavedTicketList.reloadData()
            }
            else
            {
                Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
            }
            
        }) { (dicResponse, isSuccess) in
            Singleton().showAlertWithSingleButton(strMessage: dicResponse["message"] as! String)
        }
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segToDeliveryTicketVC"
        {
            let VC : DeliveryTicketVC = segue.destination as! DeliveryTicketVC
            VC.dicTicket = sender as? NSMutableDictionary ?? NSMutableDictionary()
            VC.isFromSavedTicket = true
        }
        
    }
	
	
	@IBAction func btnBack(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	

}
