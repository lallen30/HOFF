//
//  UartBaseViewController.swift
//  HOFFER
//
//  Created by macmini on 29/08/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

// Data
enum DisplayMode {
    case text           // Display a TextView with all uart data as a String
    case table          // Display a table where each data packet is a row
}

enum ExportFormat: String {
    case txt = "txt"
    case csv = "csv"
    case json = "json"
    case xml = "xml"
    case bin = "bin"
}

class UartBaseViewController: PeripheralModelVC {

    fileprivate static let kExportFormats: [ExportFormat] = [.txt, .csv, .json/*, .xml*/, .bin]
    internal var uartData: UartPacketManagerBase!
    fileprivate var strOutput = String() //NSMutableAttributedString()
    //var tableCachedDataBuffer: [UartPacket]?
    //var displayMode: DisplayMode = .text
    
    //BLOCK FOR RESULT
    
    ///  Completion handler
    typealias CompletionBlock = ((String) -> Void)?
    var block : CompletionBlock?
    var isUpdating : Bool = false
    
    //MARK:- PROTOCOL METHODS
    private weak var didUpdatePreferencesObserver: NSObjectProtocol?
    
    private func registerNotifications(enabled: Bool) {
        let notificationCenter = NotificationCenter.default
        if enabled {
            didUpdatePreferencesObserver = notificationCenter.addObserver(forName: .didUpdatePreferences, object: nil, queue: .main) { [weak self] _ in
                self?.reloadDataUI()
            }
        } else {
            if let didUpdatePreferencesObserver = didUpdatePreferencesObserver {notificationCenter.removeObserver(didUpdatePreferencesObserver)}
        }
    }
    
    //MARK:- VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blePeripheral = Singleton.sharedSingleton.selectedPeripheral
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications(enabled: true)
        // Enable Uart
        setupUart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        registerNotifications(enabled: false)
    }
    
    //MARK:- DELIVERY TICKET SCREEN
    func sendRDTCommand(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "RDT"
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "RDT\nRDT\nProcessMsg::command == RDT\n\rMETER DELIVERY TICKET\n\rTRAILER NUMBER: \n\r1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:       62\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:48\n\rDELIVERY NUMBER:   25\n\rACCUMULATED TOTAL:\n\r     2090\n\r"
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 3.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 3.0)
    }
    
    //MARK:- CONFIGURATION SCREEN
    func send_DA_Command(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "DA"
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            
            //Possible Responses.
            
            /****************
            Done
            ****************
            "DA\nDA\nConfiguration Printout\n\r09/07/2001::03:56\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference:  NBP (1 atm)\n\rTemperature units:  Kelvin\n\rDefault temperature:   110.0\n\rPressure units:  psig\n\rDefault pressure:   235.3\n\rDelivery units:  gallons\n\rTotal decimal places:   0\n\rFluid type:  LIN\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.1\n\rTrailer number:  1234\n\rSerial number:         1\n\rMeter size (inch):  2.00\n\rK-factor method:  Average\n\rAverage K-factor:  1.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] =  822.927 \r\nFrequency[ 3] =   97.348   K-factor[ 3] =  824.481 \r\nnd of Configuration Printout\n\r" */
            
            /****************
            Done
            ****************
 */
            //self.strOutput = "DA\nDA\nConfiguration Printout\n\r10/23/2001::05:57\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference conditions:\n\rNIST (70 F, 14.7 psia)\n\rTemperature units:  Fahrenheit\n\rDefault temperature:   -10.0\n\rPressure units:  barG\n\rDefault pressure:   19.74\n\rDelivery units:  pounds\n\rTotal decimal places:   0\n\rFluid type:  N2O\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.5\n\rTrailer number:  1234\n\rSerial number:         1\n\rMeter size (inch):  1.50\n\rK-factor method:  Average\n\rAverage K-factor:  1.000\n\rFre48   K-factor[ 3] =  824.481 \r\nFrequency[ 4] =  138.628   K-factor[ 4] =  823.121 \r\nFrequency[ 5] =  206.648   K-factor[ 5] =  820.800 \r\nLast calibration date:  09/01/2009\n\rNext calibration date:  09/01/2010\n\r  \n\rEnd of Configuration Printout\n\r"
            
            /****************
            Done
            ****************
 
            self.strOutput = "DA\nDA\nConfiguration Printout\n\r10/23/2001::05:57\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference conditions:\n\rNIST (70 F, 14.7 psia)\n\rTemperature units:  Fahrenheit\n\rDefault temperature:   -10.0\n\rPressure units:  barG\n\rDefault pressure:   19.74\n\rDelivery units:  pounds\n\rTotal decimal places:   0\n\rFluid type:  N2O\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.5\n\rTrailer number:  1234\n\rSerial number:      4567\n\rMeter size (inch):  1.50\n\rK-factor method:  Average\n\rAverage K-factor:  1.000\n\rFre48   K-factor[ 3] =  824.481 \r\nFrequency[ 1] =3D   54.859   K-factor[ 4] =  823.121 \r\nFrequency[ 2] =3D   54.876   K-factor[ 5] =  820.800 \r\nLast calibration date:  09/01/2009\n\rNext calibration date:  09/01/2010\n\r  \n\rEnd of Configuration Printout\n\r" //"DA\nDA\nConfiguration Printout\n\r10/31/2018::04:29\n\r =20\n\rSoftware version: 1.102418\n\rSoftware CRC:  BAC6\n\rReference:  NBP (1 atm)\n\rTemperature units:  Kelvin\n\rDefault temperature:   110.0\n\rPressure units:  psig\n\rDefault pressure:   235.3\n\rDelivery units:  liters\n\rTotal decimal places:   0\n\rFluid type:  LIN\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE &amp; DEFAULT PRESSURE\n\rPump delay (min):   0.1\n\rTrailer number:  113366\n\rSerial number:      2255\n\rMeter size (inch):  1.50\n\rK-factor method:  Average\n\rAverage K-factor:  1.000\n\rFrequency[ 1] =3D   54.859   K-factor[ 1] =3D  822.927=20\nFrequency[ 2] =3D   54.876   K-factor[ 2] =3D  822.927=20\nFrequency[ 3] =3D   97.348   K-factor[ 3] =3D  82\n\r\n" */
            
            
            /// O6 / 11 /2018 Responces
            //self.strOutput = "DA\nDA\nConfiguration Printout\n\r11/06/2018::01:54\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference conditions:\n\rNIST (70 F, 14.7 psia)\n\rTemperature units:  Fahrenheit\n\rDefault temperature:   -10.0\n\rPressure units:  barG\n\rDefault pressure:   19.74\n\rDelivery units:  pounds\n\rTotal decimal places:   0\n\rFluid type:  N2O\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.5\n\rTrailer number:  2222\n\rSerial number:         1\n\rMeter size (inch):  1.50\n\rK-factor method:  Average\n\rAverage K-factor:  1.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] =  822.927 \r\nte:  09/01/2010\n\r  \n\rEnd of Configuration Printout\n\r"
            
            //12:35  //Done
            
           //self.strOutput = "DA\nDA\nConfiguration Printout\n\r11/06/2018::02:02\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference conditions:\n\rNIST (70 F, 14.7 psia)\n\rTemperature units:  Fahrenheit\n\rDefault temperature:   -10.0\n\rPressure units:  barG\n\rDefault pressure:   19.74\n\rDelivery units:  pounds\n\rTotal decimal places:   0\n\rFluid type:  N2O\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.5\n\rTrailer number:  2222\n\rSerial number:         1\n\rMeter size (inch):  1.50\n\rK-factor method:  Average\n\rAverage K-factor:  1.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] =  822.927date:  09/01/2010\n\r  \n\rEnd of Configuration Printout\n\r"
            
            //=================================================================================================
            //MAIL FORM THE CLIENT Mon, 5 Nov 2018 19:58:18 GMT+0530   := Done
            //self.strOutput = "DA\nSC=11/05/2018::08:35\nDA\nSC=11/05/2018::08:35\n\rConfiguration Printout\n\r11/05/2018::08:35\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  ADB\n\rReference:  NBP (1 atm)\n\rTemperature units:  Kelvin\n\rDefault temperature:   111.0\n\rPressure units:  psig\n\rDefault pressure:   235.3\n\rDelivery units:  gallons\n\rTotal decimal places:   0\n\rFluid type:  LIN\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.1\n\rTrailer number:  889966\n\rSerial number:     45678\n\rMeter size (inch):  1.00\n\rK-factor method:  Average\n\rAverage K-factor:  55.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] = 6969.000 \r\nFrequency[ 3] =   97.348   K-factor[ 3] =  8"
            
            //MAIL FORM THE CLIENT Mon, 5 Nov 2018 19:58:29 GMT+0530    := Done
            //self.strOutput = "DA\nSC=11/05/2018::08:35\nDA\nSC=11/05/2018::08:35\n\rConfiguration Printout\n\r11/05/2018::08:35\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  ADB\n\rReference:  NBP (1 atm)\n\rTemperature units:  Kelvin\n\rDefault temperature:   111.0\n\rPressure units:  psig\n\rDefault pressure:   235.3\n\rDelivery units:  gallons\n\rTotal decimal places:   0\n\rFluid type:  LIN\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.1\n\rTrailer number:  889966\n\rSerial number:     45678\n\rMeter size (inch):  1.00\n\rK-factor method:  Average\n\rAverage K-factor:  55.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] = 6969.000 \r\nFrequency[ 3] =   97.348   K-factor[ 3] =  8"
            
   //NotDone         //MAIL FORM THE CLIENT  Mon, 5 Nov 2018 19:58:39 GMT+0530
            //self.strOutput = "DA\nDA\nConfiguration Printout\n\r11/05/2018::08:54\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference conditions:\n\rNIST (70 F, 14.7 psia)\n\rTemperature units:  Fahrenheit\n\rDefault temperature:   -10.0\n\rPressure units:  barG\n\rDefault pressure:   19.74\n\rDelivery units:  pounds\n\rTotal decimal places:   0\n\rFluid type:  N2O\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.5\n\rTrailer number:  1234\n\rSerial number:         1\n\rMeter size (inch):  1.50\n\rK-factor method:  Average\n\rAverage K-factor:  1.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] =  822.927 \r\n:  09/01/2010\n\r  \n\rEnd of Configuration Printout\n\r"
            
   //NotDone          //MAIL FORM THE CLIENT Mon, 5 Nov 2018 19:59:11 GMT+0530
            //self.strOutput = "DA\nDA\nConfiguration Printout\n\r11/05/2018::08:37\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  ADB\n\rReference:  NBP (1 atm)\n\rTemperature units:  Kelvin\n\rDefault temperature:   111.0\n\rPressure units:  psig\n\rDefault pressure:   235.3\n\rDelivery units:  gallons\n\rTotal decimal places:   0\n\rFluid type:  LIN\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.1\n\rTrailer number:  111133\n\rSerial number:     45678\n\rMeter size (inch):  1.00\n\rK-factor method:  Average\n\rAverage K-factor:  55.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] = 6969.000 \r\nFrequency[ 3] =   97.348   K-factor[ 3] =  824.481 \r\nFrequency[ 4] =  138.628   K-factor[ 4] "
            
    //NotDone        //MAIL FORM THE CLIENT Mon, 5 Nov 2018 19:59:20 GMT+0530
            //self.strOutput = "DA\nDA\nConfiguration Printout\n\r11/05/2018::09:03\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  ADB\n\rReference:  NBP (1 atm)\n\rTemperature units:  Kelvin\n\rDefault temperature:   111.0\n\rPressure units:  psig\n\rDefault pressure:   235.3\n\rDelivery units:  gallons\n\rTotal decimal places:   0\n\rFluid type:  LIN\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.1\n\rTrailer number:  111133\n\rSerial number:     45678\n\rMector method:  Average\n\rAverage K-factor:  55.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] = 6969.000 \r\nFrequency[ 3] =   97.348   K-factor[ 3] =  824.481 \r\nFrequency[ 4] =  138.628   K-factor[ 4] =  823.121 \r\nFrequency[ 5] "
            
            //MAIL FORM THE CLIENT Mon, 5 Nov 2018 19:59:51 GMT+0530
   //Need to check
            //self.strOutput = "DA\nDA\nConfiguration Printout\n\r11/05/2018::09:03\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  ADB\n\rReference:  NBP (1 atm)\n\rTemperature units:  Kelvin\n\rDefault temperature:   111.0\n\rPressure units:  psig\n\rDefault pressure:   235.3\n\rDelivery units:  gallons\n\rTotal decimal places:   0\n\rFluid type:  LIN\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.1\n\rTrailer number:  11111\n\rSerial number:     45678\n\rMeter size (inch):  1.00\n\rK-factor method:  Average =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factor[ 2] = 6969.000 \r\nFrequency[ 3] =   97.348   K-factor[ 3] =  824.481 \r\nFrequency[ 4] =  138.628   K-factor[ 4] =  823.121 \r\nFrequency[ 5] =  800.000   K-factor[ 5] = 3333.000 \r\nLast calibration date:  0"
            
     //Done   // NEW RESPONSE AFTER CHANGING COMPENSATION METHODS 13/11/2018
            self.strOutput =  "02/07/2019::07:48\n\rDA\nDA\nConfiguration Printout\n\r02/07/2019::07:48\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference conditions:  NORMAL (0 C, 101.325 kPa)\n\rTemperature units:  Celcius\n\rDefault temperature:   -16.7\n\rPressure units:  psig\n\rDefault pressure:   335.3\n\rDelivery units:  kilogram\n\rTotal decimal places:   1\n\rFluid type:  CO2-DP\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE ONLY\n\rPump delay (min):   0.6\n\rTrailer number:  2233\n\rSerial number:         5\n\rMeter size (inch):  ERROR\n\rK-factor method:  Average\n\rAverage K-factor:  3.000\n\rFrequency[ 1] =  333.000   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   56.000   K-factor[ 5] =   66.000 \r\nLast calibration date:  09/01/2009\n\rNext calibration date:  09/01/2010\n\r  \n\rEnd of Configuration Printout\n\r"
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 5.0)
    }
    
    //MARK:- CONFIGURATION SET NEW VALUES
    func send_SetConfigure_Command(_ strCommand : String ,_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = strCommand
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "DLU=7\nDLU=7\nDelivery Units = massEnglish (POUNDS)\n\r"
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
    }
    
    //MARK:- Set ICE Device Time And Date Command
    func send_SetTimeAndDateOfICEDevice_Command(_ strCommand : String ,_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = strCommand
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "SC=10/24/2018::01:55\nSC=10/24/2018::01:55\nSC=10/24/2018::01:55\n\r"
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
    }
    
    func send_SetTimeAndDateOfICEDevice_Command_WithOutDelay(_ strCommand : String){
        self.strOutput = ""
        var newText = strCommand
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "SC=10/24/2018::01:55\nSC=10/24/2018::01:55\nSC=10/24/2018::01:55\n\r"
            return
        }
        send(message: newText)
    }
    
    //MARK:- TRIP REPORT SCREEN
    func send_TR0_Commands(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "TR0"
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        
        if FeatureFlags.isBypassForScreen {
             self.strOutput = "TR0\nTR0\nProcessMsg::command == TR0\n\rTRIP REPORT\n\rDATE: 09/13/2001\n\rTIME : 09:20\n\r \n\rPrinting Trip Log (NO rollover)\n\rdeliveryNumber == 26\n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    99.17\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:52\n\rDELIVERY NUMBER:   16\n\r \n\rACCUMULATED TOTAL:     1908\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   106.14\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:53\n\rDELIVERY NUMBER:   17\n\r \n\rACCUMULATED TOTAL:     1915\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   111.57\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:56\n\rDELIVERY NUMBER:   18\n\r \n\rACCUMULATED TOTAL:     1920\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   135.59\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:49\n\rDELIVERY NUMBER:   19\n\r \n\rACCUMULATED TOTAL:     1944\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   144.88\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:50\n\rDELIVERY NUMBER:   20\n\r \n\rACCUMULATED TOTAL:     1953\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   198.34\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:59\n\rDELIVERY NUMBER:   21\n\r \n\rACCUMULATED TOTAL:     2007\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   219.26\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:26\n\rDELIVERY NUMBER:   22\n\r \n\rACCUMULATED TOTAL:     2028\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    17.82\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:26\n\rDELIVERY NUMBER:   23\n\r \n\rACCUMULATED TOTAL:     2046\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    32.54\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:28\n\rDELIVERY NUMBER:   24\n\r \n\rACCUMULATED TOTAL:     2060\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    61.98\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:48\n\rDELIVERY NUMBER:   25\n\r \n\rACCUMULATED TOTAL:     2090\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    80.58\n\rUNITS: gallons @ nbp\n\rDATE: 09/04/2001\n\rTIME : 09:03\n\rDELIVERY NUMBER:   26\n\r \n\rACCUMULATED TOTAL:     2108\n\r \n\rNO ERRORS\n\r \n\rEND OF TRIP REPORT\n\r"
             NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
             self.perform(#selector(finalResponse), with: nil, afterDelay: 3.0)
             return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 3.0)
    }
    
    func send_TR_Commands(_ strPage : String ,_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "TR" + strPage
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            if strPage == "0" {
                self.strOutput = "TR0\nTR0\nProcessMsg::command == TR0\n\rTRIP REPORT\n\rDATE: 09/13/2001\n\rTIME : 09:20\n\r \n\rPrinting Trip Log (NO rollover)\n\rdeliveryNumber == 26\n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    99.17\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:52\n\rDELIVERY NUMBER:   16\n\r \n\rACCUMULATED TOTAL:     1908\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   106.14\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:53\n\rDELIVERY NUMBER:   17\n\r \n\rACCUMULATED TOTAL:     1915\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   111.57\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:56\n\rDELIVERY NUMBER:   18\n\r \n\rACCUMULATED TOTAL:     1920\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   135.59\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:49\n\rDELIVERY NUMBER:   19\n\r \n\rACCUMULATED TOTAL:     1944\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   144.88\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:50\n\rDELIVERY NUMBER:   20\n\r \n\rACCUMULATED TOTAL:     1953\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   198.34\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:59\n\rDELIVERY NUMBER:   21\n\r \n\rACCUMULATED TOTAL:     2007\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   219.26\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:26\n\rDELIVERY NUMBER:   22\n\r \n\rACCUMULATED TOTAL:     2028\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    17.82\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:26\n\rDELIVERY NUMBER:   23\n\r \n\rACCUMULATED TOTAL:     2046\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    32.54\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:28\n\rDELIVERY NUMBER:   24\n\r \n\rACCUMULATED TOTAL:     2060\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    61.98\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:48\n\rDELIVERY NUMBER:   25\n\r \n\rACCUMULATED TOTAL:     2090\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    80.58\n\rUNITS: gallons @ nbp\n\rDATE: 09/04/2001\n\rTIME : 09:03\n\rDELIVERY NUMBER:   26\n\r \n\rACCUMULATED TOTAL:     2108\n\r \n\rNO ERRORS\n\r \n\rEND OF TRIP REPORT\n\r"
            }else if strPage == "1" {
                self.strOutput = "TR1\nTR1\nProcessMsg::command == TR1\n\rTRIP REPORT\n\rDATE: 09/13/2001\n\rTIME : 09:22\n\r \n\rPrinting Trip Log (NO rollover)\n\rdeliveryNumber == 26\n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    41.06\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 11:05\n\rDELIVERY NUMBER:    6\n\r \n\rACCUMULATED TOTAL:     1250\n\r \n\rERRORS\n\rPower Loss since delivery began.\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:     0.77\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 12:18\n\rDELIVERY NUMBER:    7\n\r \n\rACCUMULATED TOTAL:     1251\n\r \n\rERRORS\n\rPower Loss since delivery began.\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    55.78\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 12:25\n\rDELIVERY NUMBER:    8\n\r \n\rACCUMULATED TOTAL:     1307\n\r \n\rERRORS\n\rPower Loss since delivery began.\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   209.96\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 12:25\n\rDELIVERY NUMBER:    9\n\r \n\rACCUMULATED TOTAL:     1516\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   196.79\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 12:26\n\rDELIVERY NUMBER:   10\n\r \n\rACCUMULATED TOTAL:     1713\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   253.35\n\rUNITS: gallons @ nbp\n\rDATE: 08/17/2001\n\rTIME : 11:03\n\rDELIVERY NUMBER:   11\n\r \n\rACCUMULATED TOTAL:     1770\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   277.37\n\rUNITS: gallons @ nbp\n\rDATE: 08/17/2001\n\rTIME : 11:04\n\rDELIVERY NUMBER:   12\n\r \n\rACCUMULATED TOTAL:     1794\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   287.44\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:39\n\rDELIVERY NUMBER:   13\n\r \n\rACCUMULATED TOTAL:     1804\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   292.09\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:43\n\rDELIVERY NUMBER:   14\n\r \n\rACCUMULATED TOTAL:     1809\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    86.00\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:44\n\rDELIVERY NUMBER:   15\n\r \n\rACCUMULATED TOTAL:     1895\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    99.17\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:52\n\rDELIVERY NUMBER:   16\n\r \n\rACCUMULATED TOTAL:     1908\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   106.14\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:53\n\rDELIVERY NUMBER:   17\n\r \n\rACCUMULATED TOTAL:     1915\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   111.57\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:56\n\rDELIVERY NUMBER:   18\n\r \n\rACCUMULATED TOTAL:     1920\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   135.59\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:49\n\rDELIVERY NUMBER:   19\n\r \n\rACCUMULATED TOTAL:     1944\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   144.88\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:50\n\rDELIVERY NUMBER:   20\n\r \n\rACCUMULATED TOTAL:     1953\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   198.34\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:59\n\rDELIVERY NUMBER:   21\n\r \n\rACCUMULATED TOTAL:     2007\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   219.26\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:26\n\rDELIVERY NUMBER:   22\n\r \n\rACCUMULATED TOTAL:     2028\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    17.82\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:26\n\rDELIVERY NUMBER:   23\n\r \n\rACCUMULATED TOTAL:     2046\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    32.54\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:28\n\rDELIVERY NUMBER:   24\n\r \n\rACCUMULATED TOTAL:     2060\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    61.98\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:48\n\rDELIVERY NUMBER:   25\n\r \n\rACCUMULATED TOTAL:     2090\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    80.58\n\rUNITS: gallons @ nbp\n\rDATE: 09/04/2001\n\rTIME : 09:03\n\rDELIVERY NUMBER:   26\n\r \n\rACCUMULATED TOTAL:     2108\n\r \n\rNO ERRORS\n\r \n\rEND OF TRIP REPORT\n\r"
            }else{
                strOutput = "TR2\nTR2\nProcessMsg::command == TR2\n\rTRIP REPORT\n\rDATE: 09/13/2001\n\rTIME : 09:25\n\r \n\rPrinting Trip Log (NO rollover)\n\rdeliveryNumber == 26\n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    17.82\n\rUNITS: gallons @ nbp\n\rDATE: 07/18/2001\n\rTIME : 14:21\n\rDELIVERY NUMBER:    1\n\r \n\rACCUMULATED TOTAL:       18\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   167.35\n\rUNITS: gallons @ nbp\n\rDATE: 07/18/2001\n\rTIME : 14:23\n\rDELIVERY NUMBER:    2\n\r \n\rACCUMULATED TOTAL:      167\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   472.08\n\rUNITS: gallons @ nbp\n\rDATE: 07/24/2001\n\rTIME : 20:33\n\rDELIVERY NUMBER:    3\n\r \n\rACCUMULATED TOTAL:      472\n\r \n\rERRORS\n\rPower Loss since delivery began.\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:  1178.68\n\rUNITS: gallons @ nbp\n\rDATE: 07/25/2001\n\rTIME : 10:56\n\rDELIVERY NUMBER:    4\n\r \n\rACCUMULATED TOTAL:     1179\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:  1208.89\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 10:57\n\rDELIVERY NUMBER:    5\n\r \n\rACCUMULATED TOTAL:     1209\n\r \n\rERRORS\n\rPower Loss since delivery began.\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    41.06\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 11:05\n\rDELIVERY NUMBER:    6\n\r \n\rACCUMULATED TOTAL:     1250\n\r \n\rERRORS\n\rPower Loss since delivery began.\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:     0.77\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 12:18\n\rDELIVERY NUMBER:    7\n\r \n\rACCUMULATED TOTAL:     1251\n\r \n\rERRORS\n\rPower Loss since delivery began.\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    55.78\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 12:25\n\rDELIVERY NUMBER:    8\n\r \n\rACCUMULATED TOTAL:     1307\n\r \n\rERRORS\n\rPower Loss since delivery began.\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   209.96\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 12:25\n\rDELIVERY NUMBER:    9\n\r \n\rACCUMULATED TOTAL:     1516\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   196.79\n\rUNITS: gallons @ nbp\n\rDATE: 08/16/2001\n\rTIME : 12:26\n\rDELIVERY NUMBER:   10\n\r \n\rACCUMULATED TOTAL:     1713\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   253.35\n\rUNITS: gallons @ nbp\n\rDATE: 08/17/2001\n\rTIME : 11:03\n\rDELIVERY NUMBER:   11\n\r \n\rACCUMULATED TOTAL:     1770\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   277.37\n\rUNITS: gallons @ nbp\n\rDATE: 08/17/2001\n\rTIME : 11:04\n\rDELIVERY NUMBER:   12\n\r \n\rACCUMULATED TOTAL:     1794\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   287.44\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:39\n\rDELIVERY NUMBER:   13\n\r \n\rACCUMULATED TOTAL:     1804\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   292.09\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:43\n\rDELIVERY NUMBER:   14\n\r \n\rACCUMULATED TOTAL:     1809\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    86.00\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:44\n\rDELIVERY NUMBER:   15\n\r \n\rACCUMULATED TOTAL:     1895\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    99.17\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:52\n\rDELIVERY NUMBER:   16\n\r \n\rACCUMULATED TOTAL:     1908\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   106.14\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:53\n\rDELIVERY NUMBER:   17\n\r \n\rACCUMULATED TOTAL:     1915\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   111.57\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 08:56\n\rDELIVERY NUMBER:   18\n\r \n\rACCUMULATED TOTAL:     1920\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   135.59\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:49\n\rDELIVERY NUMBER:   19\n\r \n\rACCUMULATED TOTAL:     1944\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   144.88\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:50\n\rDELIVERY NUMBER:   20\n\r \n\rACCUMULATED TOTAL:     1953\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   198.34\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 09:59\n\rDELIVERY NUMBER:   21\n\r \n\rACCUMULATED TOTAL:     2007\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:   219.26\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:26\n\rDELIVERY NUMBER:   22\n\r \n\rACCUMULATED TOTAL:     2028\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    17.82\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:26\n\rDELIVERY NUMBER:   23\n\r \n\rACCUMULATED TOTAL:     2046\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    32.54\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:28\n\rDELIVERY NUMBER:   24\n\r \n\rACCUMULATED TOTAL:     2060\n\r \n\rERRORS\n\rMin Delivery Not Reached\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    61.98\n\rUNITS: gallons @ nbp\n\rDATE: 08/28/2001\n\rTIME : 10:48\n\rDELIVERY NUMBER:   25\n\r \n\rACCUMULATED TOTAL:     2090\n\r \n\rNO ERRORS\n\r \n\r \n\rTRAILER NUMBER: 1234\n\rPRODUCT NAME: LIN\n\rDELIVERY:    80.58\n\rUNITS: gallons @ nbp\n\rDATE: 09/04/2001\n\rTIME : 09:03\n\rDELIVERY NUMBER:   26\n\r \n\rACCUMULATED TOTAL:     2108\n\r \n\rNO ERRORS\n\r \n\rEND OF TRIP REPORT\n\r"
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 5.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 5.0)
    }
    
    //MARK:- AUDIT TRIAL SCREEN
    func send_AT_Commands(_ strPage : String ,_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "AT" + strPage
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            if strPage == "0" {
                self.strOutput = "AT0\nAT0\nProcessMsg::command == AT0\n\rPrinting Audit Trail\n\r  \n\rBEGIN AUDIT TRAIL\n\rDATE: 09/26/2001\n\rTIME : 10:31\u{03}\n\r \n\r1 09/21/2001::09:55 DFP\n\r250.000 113.696 psia\n\r2 09/21/2001::10:01 DFT\n\r110.000 K 99.000 K\n\r3 09/21/2001::10:06 DLU\n\rGAL@NBP POUND\n\r4 09/21/2001::10:10 CPM\n\rTDP NONE\n\r5 09/21/2001::10:36 FLU\n\rLIN CO2S\n\r6 09/21/2001::10:48 MSZ\n\r2.00  1.50\n\r7 09/26/2001::10:28 DFP\n\r350.000 214.696 psia\n\r  \n\rEND OF AUDIT TRAIL\n\r"
            }else if strPage == "1" {
                self.strOutput = "AT1\nAT1\nProcessMsg::command == AT1\n\rPrinting Audit Trail\n\rPrint Audit Log attempted while delivery\n\r"
            }else{
                strOutput = ""
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 2.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 5.0)
    }
    
    //MARK:- MONITOR DELIVERY  SCREEN
    func send_DELIVERY_START_Commands(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "AA"
        self.isUpdating = true
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "AA\nAA\nR=    0.0  T=    57.3  GT=     2425  T(K)= 110.0  P(psig)= 235.3\n\rR=    0.0  T=    57.3  GT=     2425  T(K)= 110.0  P(psig)= 235.3\n\rR=    0.0  T=    57.3  GT=     2425  T(K)= 110.0  P(psig)= 235.3\n\rR=    0.0  T=    57.3  GT=     2425  T(K)= 110.0  P(psig)= 235.3\n\rR=    0.0  T=    57.3  GT=     2425  T(K)= 110.0  P(psig)= 235.3\n\rR=    0.0  T=   29012121212.1  GT=     3488  T(F)= -10.0  P(barG)=  19.7\n\r"
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 3.0)
            return
        }
        send(message: newText)
    }
    
    
    func sendGASCommand(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "GAS"
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "GAS\nGAS\nProcessMsg::command == GAS\n\rFluid Type          = LIN\r\n"
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 2.0)
    }
    
    func sendDLUCommand(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "DLU"
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "DLU\n\n\rDLU\nProcessMsg::command == DLU\n\rDelivery Units = massMetric (KILOGRAMS)\n\r"
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 2.0)
    }
    
    
    func sendREFCommand(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "REF"
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "REF\nREF\nProcessMsg::command == REF\n\rReference Conditions  = NIST\n\r"
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 2.0)
    }
    
    func send_US_Command(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "US"
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = "US\nUS\nUNIT STATUS             =      2359296\r\n"
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 1.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 2.0)
    }
    
    func send_DELIVERY_STOP_Commands(_ completion: CompletionBlock){
        self.strOutput = ""
        self.block = completion
        var newText = "" //RDT
        self.isUpdating = false
        // Eol
        if Preferences.uartIsAutomaticEolEnabled {
            newText += Preferences.uartEolCharacters
        }
        if FeatureFlags.isBypassForScreen {
            self.strOutput = ""
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finalResponse), object: nil)
            self.perform(#selector(finalResponse), with: nil, afterDelay: 5.0)
            return
        }
        send(message: newText)
        self.perform(#selector(finalResponse), with: nil, afterDelay: 0.5)
    }
    
    // MARK: - UART
    internal func isInMultiUartMode() -> Bool {
        assert(false, "Should be implemented by subclasses")
        return false
    }
    
    internal func setupUart() {
        assert(false, "Should be implemented by subclasses")
    }
    
    internal func send(message: String) {
        assert(false, "Should be implemented by subclasses")
    }
    
    internal func colorForPacket(packet: UartPacket) -> UIColor {
        assert(false, "Should be implemented by subclasses")
        return .black
    }
    
    //MARK:- RELOAD UI METODS
    private func reloadDataUI() {
        strOutput = ""
        let dataPackets = uartData.packetsCache()
        for dataPacket in dataPackets {
            onUartPacketText(dataPacket)
        }
    }
    
    fileprivate func onUartPacketText(_ packet: UartPacket) {
        guard Preferences.uartIsEchoEnabled || packet.mode == .rx else { return }
        guard let string = stringFromData(packet.data, useHexMode: Preferences.uartIsInHexMode) else {
            return
        }
        // APPEND RESULT
        strOutput.append(string)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
private func dataAsDebug(_ data: Data) -> String {
    if let str = String(data: data, encoding: .ascii) {
       return Utilities.debugEscape(str)
    } else {
       return "#NON-ASCII-STRING#"
    }
}
// MARK: - UartPacketManagerDelegate
extension UartBaseViewController: UartPacketManagerDelegate {
    
    func onUartPacket(_ packet: UartPacket) {
        onUartPacketText(packet)
        if packet.mode == .rx {
            print("RX onUartPacket(\(dataAsDebug(packet.data))")
            HofferResponseParser.instance.receivedBytes(packet.data)
        }
        self.enh_throttledReloadData()
    }
    
    @objc func reloadFinalResultWithTimer(){
        print("reloadata fetching : \(strOutput) ==============")
        self.block!!(strOutput)
    }
    
    @objc func finalResponse() {
        //print("reloadData")
		self.strOutput =  "02/07/2019::07:48\n\rDA\nDA\nConfiguration Printout\n\r02/07/2019::07:48\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference conditions:  NORMAL (0 C, 101.325 kPa)\n\rTemperature units:  Celcius\n\rDefault temperature:   -16.7\n\rPressure units:  psig\n\rDefault pressure:   335.3\n\rDelivery units:  kilogram\n\rTotal decimal places:   1\n\rFluid type:  CO2-DP\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE ONLY\n\rPump delay (min):   0.6\n\rTrailer number:  2233\n\rSerial number:         5\n\rMeter size (inch):  ERROR\n\rK-factor method:  Average\n\rAverage K-factor:  3.000\n\rFrequency[ 1] =  333.000   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   56.000   K-factor[ 5] =   66.000 \r\nLast calibration date:  09/01/2009\n\rNext calibration date:  09/01/2010\n\r  \n\rEnd of Configuration Printout\n\r"
		print("FinalResponse : \(self.strOutput) ==============")
        if self.block != nil {
			self.block!!(self.strOutput)
        }
    }
    
    
    @objc func reloadData() {
        //print("reloadData")
        if self.isUpdating {
            if self.block != nil {
                self.block!!(strOutput)
            }
        }
    }
    
    func mqttUpdateStatusUI() {
        print("mqttUpdateStatusUI")

    }
    
    func mqttError(message: String, isConnectionError: Bool) {
        let localizationManager = LocalizationManager.shared
        
        let alertMessage = isConnectionError ? localizationManager.localizedString("Connection Error") : message
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: localizationManager.localizedString("OK"), style: .default, handler:nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MqttManagerDelegate
extension UartBaseViewController: MqttManagerDelegate {
    func onMqttConnected() {
        DispatchQueue.main.async {
            self.mqttUpdateStatusUI()
        }
    }
    
    func onMqttDisconnected() {
        DispatchQueue.main.async {
            self.mqttUpdateStatusUI()
        }
    }
    
    @objc func onMqttMessageReceived(message: String, topic: String) {
        assert(false, "should be overrided by subclasses")
    }
    
    func onMqttError(message: String) {
        let mqttManager = MqttManager.shared
        let status = mqttManager.status
        let isConnectionError = status == .connecting
        
        DispatchQueue.main.async {
            self.mqttError(message: message, isConnectionError: isConnectionError)
        }
    }
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
