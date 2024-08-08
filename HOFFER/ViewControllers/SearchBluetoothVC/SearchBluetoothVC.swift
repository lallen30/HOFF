//
//  SearchBluetoothVC.swift
//  HOFFER
//
//  Created by SiliconMac on 25/07/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class SearchBluetoothVC: UIViewController {
	
	//MARK: IBOutlets
    
    @IBOutlet weak var btnBluetoothConnection: UIButton!
    @IBOutlet weak var tblDevice: UITableView!
    @IBOutlet weak var viewTable: UIView!
	
	
	//MARK: Properties
    
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var infoAlertController: UIAlertController?
    fileprivate var arrPeripheralList: PeripheralList!
    fileprivate var selectedPeripheral: BlePeripheral?
    let reuseIdentifier = "PeripheralCell"
    
    var logIn = false
    
    // MARK: BLE Notifications
	
    private weak var didUpdateBleStateObserver: NSObjectProtocol?
    private weak var didDiscoverPeripheralObserver: NSObjectProtocol?
    private weak var willConnectToPeripheralObserver: NSObjectProtocol?
    private weak var didConnectToPeripheralObserver: NSObjectProtocol?
    private weak var didDisconnectFromPeripheralObserver: NSObjectProtocol?
    private weak var peripheralDidUpdateNameObserver: NSObjectProtocol?
    fileprivate var isBaseTableScrolling = false
    fileprivate var isScannerTableWaitingForReload = false
    fileprivate var isBaseTableAnimating = false
    
    private func registerNotifications(enabled: Bool) {
        let notificationCenter = NotificationCenter.default
        if enabled {
            didUpdateBleStateObserver = notificationCenter.addObserver(forName: .didUpdateBleState, object: nil, queue: .main, using: {[weak self] _ in _ = self?.didUpdateBleState()})
            didDiscoverPeripheralObserver = notificationCenter.addObserver(forName: .didDiscoverPeripheral, object: nil, queue: .main, using: {[weak self] _ in self?.didDiscoverPeripheral()})
            willConnectToPeripheralObserver = notificationCenter.addObserver(forName: .willConnectToPeripheral, object: nil, queue: .main, using: {[weak self] notification in self?.willConnectToPeripheral(notification: notification)})
            didConnectToPeripheralObserver = notificationCenter.addObserver(forName: .didConnectToPeripheral, object: nil, queue: .main, using: {[weak self] notification in self?.didConnectToPeripheral(notification: notification)})
            didDisconnectFromPeripheralObserver = notificationCenter.addObserver(forName: .didDisconnectFromPeripheral, object: nil, queue: .main, using: {[weak self] notification in self?.didDisconnectFromPeripheral(notification: notification)})
            peripheralDidUpdateNameObserver = notificationCenter.addObserver(forName: .peripheralDidUpdateName, object: nil, queue: .main, using: {[weak self] notification in self?.peripheralDidUpdateName(notification: notification)})
        } else {
            if let didUpdateBleStateObserver = didUpdateBleStateObserver {notificationCenter.removeObserver(didUpdateBleStateObserver)}
            if let didDiscoverPeripheralObserver = didDiscoverPeripheralObserver {notificationCenter.removeObserver(didDiscoverPeripheralObserver)}
            if let willConnectToPeripheralObserver = willConnectToPeripheralObserver {notificationCenter.removeObserver(willConnectToPeripheralObserver)}
            if let didConnectToPeripheralObserver = didConnectToPeripheralObserver {notificationCenter.removeObserver(didConnectToPeripheralObserver)}
            if let didDisconnectFromPeripheralObserver = didDisconnectFromPeripheralObserver {notificationCenter.removeObserver(didDisconnectFromPeripheralObserver)}
            if let peripheralDidUpdateNameObserver = peripheralDidUpdateNameObserver {notificationCenter.removeObserver(peripheralDidUpdateNameObserver)}
        }
    }
    
  
    
    //MARK: VIEW DIDLOAD MEHTODS
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        arrPeripheralList = PeripheralList()
        arrPeripheralList.setDefaultFilters()
        
        // Setup table view
        tblDevice.register(UINib(nibName:"PeripheralCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tblDevice.estimatedRowHeight = 66
		tblDevice.rowHeight = UITableView.automaticDimension
        
        // Setup table refresh
        //refreshControl.addTarget(self, action: #selector(onTableRefresh(_:)), for: UIControlEvents.valueChanged)
        //tblDevice.addSubview(refreshControl)
        //tblDevice.sendSubview(toBack: refreshControl)
        
        if logIn == false{
            
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewViewController") as! LoginViewViewController
//            //let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewViewController") as! LoginViewViewController
//               //self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        viewTable.isHidden = true
        _ = didUpdateBleState()
        
        //// Start scannning Auto Debuging
        ////*******************************************
        if FeatureFlags.isDebugClientDesk {
            BleManager.shared.startScan()
            viewTable.isHidden = false
            self.perform(#selector(doConnnnect), with: nil, afterDelay: 10.0)
        }
        
        ////*******************************************
        
        //Ble Notifications
        registerNotifications(enabled: true)
    }

    @objc func doConnnnect() {
        let peripheral = arrPeripheralList.filteredPeripherals(forceUpdate: false)[0]
        DispatchQueue.global(qos: .background).async {
            self.connect(peripheral: peripheral)
        }
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Stop scanning
        BleManager.shared.stopScan()
        
        //Ble Notifications
        registerNotifications(enabled: false)
        
        // Clear peripherals
        arrPeripheralList.clear()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    @IBAction func btnBluetoothConnectionPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSkipPressed(_ sender: UIButton) {
        APPDELEGATE.isBTOffline = true
//        self.performSegue(withIdentifier: "HomeViewController", sender: nil)
        let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
		vc?.comeFrom = "Skip"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func btnLogout(_ sender: UIButton) {
        UserDefaults.standard.setValue(false, forKey: "isUserLogin")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearchPressed(_ sender: UIButton) {
        
        //BY PASS WHEN CLICK SEARCH
        guard !FeatureFlags.isBypassForScreen else {
            self.gotoDetailsViewcontroller()
            //self.openAlertView()
            return
        }

        // ORIGINAL CODE HERE
        if didUpdateBleState() {
            self.refreshPeripherals()
            viewTable.isHidden = false
        }
        
    }
    
    //MARK:- BLE OBSERVER METHODS
    private func didUpdateBleState() -> Bool {
        guard let state = BleManager.shared.centralManager?.state else {
            print("BleManager.shared.centralManager --> Error")
            return false
        }
        
        // Check if there is any error
        var errorMessageId: String?
        switch state {
        case .unsupported:
            errorMessageId = "This device doesn't support Bluetooth Low Energy"
        case .unauthorized:
            errorMessageId = "This app is not authorized to use the Bluetooth Low Energy"
        case .poweredOff:
            errorMessageId = "Bluetooth is currently powered off."
        default:
            errorMessageId = nil
        }
        
        // Show alert if error found
        if let errorMessageId = errorMessageId {
            let localizationManager = LocalizationManager.shared
            let errorMessage = localizationManager.localizedString(errorMessageId)
            DLog("Error: \(errorMessage)")
            
            // Reload peripherals
            refreshPeripherals()
            
            // Show error
            Singleton().showAlertWithSingleButton(strMessage: errorMessage)
            return false
        }else{
            return true
        }
    }
    
    private func didDiscoverPeripheral() {
        /*
         #if DEBUG
         let peripheralUuid = notification.userInfo?[BleManager.NotificationUserInfoKey.uuid.rawValue] as? UUID
         let peripheral = BleManager.sharedInstance.peripherals().first(where: {$0.identifier == peripheralUuid})
         DLog("didDiscoverPeripheral: \(peripheral?.name ?? "")")
         #endif
         */
        
        // Update current scanning state
        updateScannedPeripherals()
    }
    
    private func willConnectToPeripheral(notification: Notification) {
        guard let peripheral = BleManager.shared.peripheral(from: notification) else { return }
        presentInfoDialog(title: "Connecting...", peripheral: peripheral)
    }
    
    private func didConnectToPeripheral(notification: Notification) {
        //updateMultiConnectUI()
        guard let selectedPeripheral = selectedPeripheral, let identifier = notification.userInfo?[BleManager.NotificationUserInfoKey.uuid.rawValue] as? UUID, selectedPeripheral.identifier == identifier else {
            DLog("Connected to an unexpected peripheral")
            return
        }
        
        // Discover services
        //infoAlertController?.message = "Discovering services..."
        discoverServices(peripheral: selectedPeripheral)
    }
    
    private func didDisconnectFromPeripheral(notification: Notification) {
        //updateMultiConnectUI()
        
        let peripheral = BleManager.shared.peripheral(from: notification)
        let currentlyConnectedPeripheralsCount = BleManager.shared.connectedPeripherals().count
        
        guard let selectedPeripheral = selectedPeripheral, selectedPeripheral.identifier == peripheral?.identifier || currentlyConnectedPeripheralsCount == 0 else {        // If selected peripheral is disconnected or if there not any peripherals connected (after a failed dfu update)
            return
        }
        
        // Clear selected peripheral
        self.selectedPeripheral = nil
        
        // Watch
        //WatchSessionManager.shared.updateApplicationContext(mode: .scan)
        
        // Dismiss any info open dialogs
        infoAlertController?.dismiss(animated: true, completion: nil)
        infoAlertController = nil
        
        // Reload table
        reloadBaseTable()
    }
    
    private func peripheralDidUpdateName(notification: Notification) {
        let name = notification.userInfo?[BlePeripheral.NotificationUserInfoKey.name.rawValue] as? String
        DLog("centralManager peripheralDidUpdateName: \(name ?? "<unknown>")")
        
        DispatchQueue.main.async {
            // Reload table
            self.reloadBaseTable()
        }
    }
    
    fileprivate func refreshPeripherals() {
        //isRowDetailOpenForPeripheral.removeAll()
        BleManager.shared.refreshPeripherals()
        reloadBaseTable()
    }
    
    // MARK: - UPDATE UI
    private func updateScannedPeripherals() {
        // Reload table
        if isBaseTableScrolling || isBaseTableAnimating {
            isScannerTableWaitingForReload = true
        } else {
            reloadBaseTable()
        }
    }
    
    fileprivate func reloadBaseTable() {
		DispatchQueue.main.async {
			self.isBaseTableScrolling = false
			self.isBaseTableAnimating = false
			self.isScannerTableWaitingForReload = false
			let filteredPeripherals = self.arrPeripheralList.filteredPeripherals(forceUpdate: true)     // Refresh the peripherals
			self.tblDevice.reloadData()
			
			if let selectedPeripheral = self.selectedPeripheral, let selectedRow = filteredPeripherals.index(of: selectedPeripheral) {
				self.tblDevice.selectRow(at: IndexPath(row: selectedRow, section: 0), animated: false, scrollPosition: .none)
			}
		}
        
    }
    
    fileprivate func gotoDetailsViewcontroller() {
        Singleton.sharedSingleton.selectedPeripheral = self.selectedPeripheral
        APPDELEGATE.isBTOffline = false
//        self.performSegue(withIdentifier: "segToDashboardVC", sender: nil)
		
		let vc = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
		self.navigationController?.pushViewController(vc!, animated: true)
		
    }
     //MARK:- BLE METHODS FOR DISCOVERING
    private func discoverServices(peripheral: BlePeripheral) {
        peripheral.discover(serviceUuids: nil) { [weak self] error in
            guard let context = self else { return }
            //let localizationManager = LocalizationManager.shared
            DispatchQueue.main.async {
                guard error == nil else {
                    //DLog("Error initializing peripheral")
                    context.dismiss(animated: true, completion: { [weak self] () -> Void in
                        if let context = self {
                            showErrorAlert(from: context, title: "Error", message: "Error discovering peripheral services")
                            BleManager.shared.disconnect(from: peripheral)
                        }
                    })
                    return
                }
                context.dismissInfoDialog {
                    self?.gotoDetailsViewcontroller()
                }
            }
        }
    }
    
    fileprivate func dismissInfoDialog(completion: (() -> Void)? = nil) {
        guard infoAlertController != nil else {
            completion?()
            return
        }
        
        infoAlertController?.dismiss(animated: true, completion: completion)
        infoAlertController = nil
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segToDashboardVC"
        {
            //let VC : DashboardVC = segue.destination as! DashboardVC
            //VC.blePeripheral = self.selectedPeripheral
        }
        
    }
    
}
// MARK: - TABLEVIEW EXTENSION
extension SearchBluetoothVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  arrPeripheralList.filteredPeripherals(forceUpdate: false).count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let peripheralCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PeripheralCell
        
        // Note: not using willDisplayCell to avoid problems with self-sizing cells
        let peripheral = arrPeripheralList.filteredPeripherals(forceUpdate: false)[indexPath.row]
        
        // Fill data
        //let localizationManager = LocalizationManager.shared
        var isFound: Bool = false
        for aDevice in Singleton.sharedSingleton.arrDevicesNames {
            if aDevice.strUUID == peripheral.identifier.uuidString {
                isFound = true
                peripheralCell.titleLabel.text = aDevice.strName
                break
            }
        }
        
        if !isFound{
            peripheralCell.titleLabel.text = peripheral.name ?? "<Unknown>" // localizationManager.localizedString("scanner_unnamed")
            //peripheralCell.rssiImageView.image = RssiUI.signalImage(for: peripheral.rssi)
        }
        
        var subtitle: String? = nil
        if peripheral.advertisement.isConnectable == false {
            subtitle = "Not Connectable" //localizationManager.localizedString("scanner_notconnectable")
            peripheralCell.connectButton.alpha = 0.7
            peripheralCell.connectButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        else if peripheral.isUartAdvertised() {
            subtitle = "Uart capable" //localizationManager.localizedString("scanner_uartavailable")
            peripheralCell.connectButton.alpha = 1.0
            peripheralCell.connectButton.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        }
        else
        {
            peripheralCell.connectButton.alpha = 0.7
            peripheralCell.connectButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        peripheralCell.subtitleLabel.text = subtitle
        
        let isFullScreen = UIScreen.main.traitCollection.horizontalSizeClass == .compact
        let showConnect: Bool
        let showDisconnect: Bool
        showConnect = isFullScreen || selectedPeripheral == nil
        showDisconnect = !isFullScreen && peripheral.identifier == selectedPeripheral?.identifier
        
        /*if isMultiConnectEnabled {
            let connectedPeripherals = BleManager.shared.connectedPeripherals()
            showDisconnect = connectedPeripherals.contains(peripheral)
            showConnect = !showDisconnect
        } else {
         
        }*/
        
        peripheralCell.connectButton.isHidden = !showConnect
        peripheralCell.disconnectButton.isHidden = !showDisconnect
        
        peripheralCell.connectButton.titleLabel?.text = "   Connect   " //localizationManager.localizedString("scanner_connect")
        peripheralCell.disconnectButton.titleLabel?.text = "   Disconnect   " //localizationManager.localizedString("scanner_disconnect")
        
        peripheralCell.onConnect = { [unowned self] in
            DispatchQueue.global(qos: .background).async {
                self.connect(peripheral: peripheral)
            }
        }
        peripheralCell.onDisconnect = { [unowned self] in
            tableView.deselectRow(at: indexPath, animated: true)
            self.disconnect(peripheral: peripheral)
        }
        return peripheralCell
    }
    
    // MARK: - Connections
    fileprivate func connect(peripheral: BlePeripheral) {
        selectedPeripheral = peripheral
        DispatchQueue.global(qos: .background).async {
            BleManager.shared.connect(to: peripheral)
        }
        DispatchQueue.main.async {
            self.reloadBaseTable()
        }
    }

    
    fileprivate func disconnect(peripheral: BlePeripheral) {
        selectedPeripheral = nil
        BleManager.shared.disconnect(from: peripheral)
        reloadBaseTable()
    }
    
    fileprivate func presentInfoDialog(title: String, peripheral: BlePeripheral) {
        if infoAlertController != nil {
            infoAlertController?.dismiss(animated: true, completion: nil)
        }
        
        infoAlertController = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        infoAlertController!.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            BleManager.shared.disconnect(from: peripheral)
        }))
        present(infoAlertController!, animated: true, completion:nil)
    }
}

