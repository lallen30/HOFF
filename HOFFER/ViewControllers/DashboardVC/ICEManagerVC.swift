//
//  ICECommandManagerViewController.swift
//  HOFFER
//
//  Created by macmini on 18/09/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class ICEManagerVC: UartBaseViewController {
    static let shared = ICEManagerVC()
    
    fileprivate var colorForPeripheral = [UUID: UIColor]()
    typealias successBlock = ((String) -> Void)?
    
    
    //MARK:- SEND COMMAND METHODS FOR DASHBOARD
    func DidLoad(){
        self.viewDidLoad()
        uartData = UartPacketManager(delegate: self, isPacketCacheEnabled: true, isMqttEnabled: true)
        print(uartData.debugDescription)
    }
    
    func WillAppear(animated:Bool){
        self.viewWillAppear(animated)
        
    }
    
    func DidDisappear(){
        
    }
        
    //MARK:- Arduino Bluetooth Send Command Methods
    override func setupUart() {
        if let blePeripheral = blePeripheral          //  Single peripheral mode
        {
            blePeripheral.uartEnable(uartRxHandler: uartData.rxPacketReceived) { [weak self] error in
                
                guard let context = self else { return }
                
                DispatchQueue.main.async {
                    
                    guard error == nil else {
                        
                        DLog("Error initializing uart")
                        
                        context.dismiss(animated: true, completion: { [weak self] in
                            
                            if let context = self
                            {
                                showErrorAlert(from: context, title: "Error", message:"Uart protocol can not be initialized")                                
                                if let blePeripheral = context.blePeripheral
                                {
                                    BleManager.shared.disconnect(from: blePeripheral)
                                }
                            }
                        })
                        return
                    }
                    
                    // Done
                    print("Uart enabled")
                    //DLog("Uart enabled")
                    //context.updateUartReadyUI(isReady: true)
                }
            }
        }
    }
    
    
    override func send(message: String) {
        print(message)
        guard let uartData = self.uartData as? UartPacketManager else {
            DLog("Error send with invalid uartData class");
            return
        }
        
        if let blePeripheral = blePeripheral // Single peripheral mode
        {
            print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   Command fire :---- >  \(message)")
            uartData.send(blePeripheral: blePeripheral, text: message)
        }
        else // Multiple peripheral mode
        {
            let peripherals = BleManager.shared.connectedPeripherals()
            // Send to all peripherals
            for peripheral in peripherals
            {
                uartData.send(blePeripheral: peripheral, text: message)
            }
            
        }
    }
    
    // MARK: - Style
    override func colorForPacket(packet: UartPacket) -> UIColor {
        
        var color: UIColor?
        
        if let peripheralId = packet.peripheralId
        {
            color = colorForPeripheral[peripheralId]
        }
        
        return color ?? UIColor.black
    }
    
    
    override func onMqttMessageReceived(message: String, topic: String) {
        guard let blePeripheral = blePeripheral else { return }
        guard let uartData = self.uartData as? UartPacketManager else { DLog("Error send with invalid uartData class"); return }
        
        DispatchQueue.main.async {
            uartData.send(blePeripheral: blePeripheral, text: message, wasReceivedFromMqtt: true)
        }
    }
    
}


