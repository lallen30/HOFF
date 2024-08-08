//
//  String+RegEx.swift
//
//
//  Created by self on 6/26/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit


//"DA\nDA\nConfiguration Printout\n\r09/27/2001::01:36\n\r  \n\rSoftware version: 1.061318\n\rSoftware CRC:  FFFF\n\rReference conditions:\n\rNIST (70 F, 14.7 psia)\n\rTemperature units:  Kelvin\n\rDefault temperature:   256.5\n\rPressure units:  psig\n\rDefault pressure:   99.0\n\rDelivery units:  pounds\n\rTotal decimal places:   0\n\rFluid type:  CO2-SP\n\rDisplay T/O (min):    10\n\rCompensation method:\n\rTEMPERATURE & DEFAULT PRESSURE\n\rPump delay (min):   0.5\n\rTrailer number:  1234\n\rSerial number:         1\n\rMeter size (inch):  1.50\n\rK-factor method:  Average\n\rAverage K-factor:  1.000\n\rFrequency[ 1] =   54.859   K-factor[ 1] =  822.927 \r\nFrequency[ 2] =   54.876   K-factoion date:  09/01/2010\n\r  \n\rEnd of Configuration Printout\n\r"

extension String {
    func isValidString(_ string: String, _ type: Global.kStringType) -> Bool {
        var charSet: CharacterSet?
        if type == Global.kStringType.AlphaNumeric {
            charSet = self.regexForAlphaNumeric()
        }
        else if type == Global.kStringType.AlphabetOnly {
            charSet = self.regexForAlphabetsOnly()
        }
        else if type == Global.kStringType.NumberOnly {
            charSet = self.regexForNumbersOnly()
        }
        else if type == Global.kStringType.Fullname {
            charSet = self.regexForFullnameOnly()
        }
        else if type == Global.kStringType.Username {
            charSet = self.regexForUsernameOnly()
        }
        else if type == Global.kStringType.Email {
            charSet = self.regexForEmail()
        }
        else if type == Global.kStringType.PhoneNumber {
            charSet = self.regexForPhoneNumber()
        }
        else {
            return true
        }
        
        let isValid: Bool = !(self.isValidStringForCharSet(string, charSet: charSet!).count == 0)
        return isValid
    }

    func isValidStringForCharSet(_ string: String, charSet: CharacterSet) -> String {
        var strResult: String = ""
        let scanner = Scanner(string: string)
        var strScanResult : NSString?
        
        scanner.charactersToBeSkipped = nil
        
        while !scanner.isAtEnd {
            if scanner.scanUpToCharacters(from: charSet, into: &strScanResult) {
                strResult = strResult + (strScanResult! as String)
            }
            else {
                if !scanner.isAtEnd {
                    scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
                }
            }
        }
        return strResult
    }
    
    // FIXME:  None of these are Regex.  In fact, they are all characterSets.  They also aren't positive character sets, they are in fact negative character sets.  They contain characters that are not in the item on their label.  But not only that, many of them are only partial negative character sets, they do not contain all possible characters that are not in the set.  How do people do these things?  The naming is wrong, the logic is wrong, the strategy is bad, the implementation is wrong.
    func regexForAlphabetsOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n_!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~`-1234567890 ")
        return regex
    }
    
    func regexForNumbersOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "1234567890").inverted
        return regex
    }
    
    func regexForAlphaNumeric() -> CharacterSet {
        let regex = CharacterSet(charactersIn: " \n_!@#$%^&*()[ ]{}'\".,<>:;|\\/?+=\t~`")
        return regex
    }
    
    func regexForFullnameOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n_!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~`-1234567890")
        return regex
    }
    
    func regexForUsernameOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~` ")
        return regex
    }
    
    func regexForPhoneNumber() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "1234567890").inverted
        return regex
    }
    
    func regexForEmail() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n!#$^&*()[ ]{}'\",<>:;|\\/?=\t~`")
        return regex
    }
    
    //MARK:- TR COMMAND
    func ConvertArduino_AT_Command_ToArray() -> NSMutableArray {
        let arrFinalTripReports = NSMutableArray()
        let arrTripReports = NSMutableArray.init(array: self.components(separatedBy: "TIME :"))
        if arrTripReports.count > 1
        {
            arrTripReports.removeObject(at: 0)
            if arrTripReports.count > 0
            {
                for strTicketPacket in arrTripReports
                {
                    var strNewToOutput = "\(strTicketPacket)"
                    strNewToOutput = strNewToOutput.replace("::", replacement: "-")
                    let arrNew = NSMutableArray.init(array: strNewToOutput.components(separatedBy: "\n\r"))
                    arrNew.removeObject(at: 0)
                    arrNew.remove("")
                    arrNew.remove(" ")
                    arrNew.removeLastObject()
                    for (index,keyValue) in arrNew.enumerated()
                    {
                        let CurrentIndex = index + 1
                        if (CurrentIndex % 2) == 0 {
                            continue
                        }else{
                            let strKeyValue = "\(keyValue)"
                            if (strKeyValue.trimmingCharacters(in: .whitespacesAndNewlines)).count > 0 {
                                let tuple = self.getFirstValueIN_Key(strKey: strKeyValue)
                                if arrNew.count > CurrentIndex {
                                    let tuple2 = self.getFirstValueIN_Key(strKey: "\(arrNew[CurrentIndex])")
                                    print("DATE:- \(tuple.1),TYPE:- \(tuple.2), VALUE_1:- \(tuple2.0), VALUE_2:- \(tuple2.1), UNIT:- \(tuple2.2)")
                                    let tmpDic = OrderedDictionary()
                                    tmpDic.setValue(tuple.1, forKey: "date")
                                    tmpDic.setValue(tuple.2, forKey: "type")
                                    tmpDic.setValue(tuple2.0, forKey: "value1")
                                    tmpDic.setValue(tuple2.1, forKey: "value2")
                                    //tmpDic.setValue(tuple2.2, forKey: "unit")
                                    arrFinalTripReports.add(tmpDic)
                                    //["date":tuple.1,"type":tuple.2,"value1":tuple2.0,"value2":tuple2.1,"unit":tuple2.2]
                                }
                            }                            
                        }
                    }
                    print("Results:- \(arrFinalTripReports)")
                }
            }
        }
        return arrFinalTripReports
    }
    
    func getFirstValueIN_Key(strKey:String) -> (String, String, String){
        //"1 09/21/2001-09:55 DFP"
        let arr = strKey.components(separatedBy:" ")
        return (arr.first ?? " - ", (arr.count > 1) ? arr[1]:" - ", (arr.count > 2) ? arr[2]:" - ")
    }
    
    
    
    //MARK:- TR COMMAND
    func ConvertArduinoTRCommandToArray() -> NSMutableArray {
        
        //self.arrTripReports = self.strOutPut.ConvertArduinoRDTCommandToArray()
        let arrFinalTripReports = NSMutableArray()
        let arrTicket = NSMutableArray()
        let TmpstrNewToOutput = self
        
        let arrTripReports = NSMutableArray.init(array: TmpstrNewToOutput.components(separatedBy: "TRAILER NUMBER"))
        if arrTripReports.count > 1
        {
            arrTripReports.removeObject(at: 0)
            if arrTripReports.count > 1
            {
                for strTicketPacket in arrTripReports
                {
                    var strNewToOutput = "TRAILER NUMBER" + "\(strTicketPacket)"
                    if strNewToOutput.contains("NO ERRORS")
                    {
                        strNewToOutput = strNewToOutput.replacingOccurrences(of: "NO ERRORS", with: "ISSUE : nil")
                    }
                    else if strNewToOutput.contains("ERRORS\n\r")
                    {
                        strNewToOutput = strNewToOutput.replacingOccurrences(of: "ERRORS\n\r", with: "ISSUE :")
                    }
                    let arrNew = NSMutableArray.init(array: strNewToOutput.components(separatedBy: "\n\r"))
                    arrNew.remove("")
                    arrNew.remove(" ")
                    let arrTmpReport = NSMutableArray()
                    for keyValue in arrNew
                    {
                        let strKeyValue = "\(keyValue)"
                        if strKeyValue.contains(":")
                        {
                            var strKey = ""
                            var strValue = ""
                            var isSepratorFound = false
                            var foundCharInKey = false
                            var foundCharInValue = false
                            
                            for word in strKeyValue
                            {
                                if isSepratorFound
                                {
                                    if word == " " && !foundCharInValue
                                    {
                                        
                                    }
                                    else
                                    {
                                        foundCharInValue = true
                                        strValue = "\(strValue)" + "\(word)"
                                    }
                                }
                                else
                                {
                                    if word == ":"
                                    {
                                        isSepratorFound = true
                                        continue
                                    }
                                    if word == " " && !foundCharInKey
                                    {
                                        
                                    }
                                    else
                                    {
                                        foundCharInKey = true
                                        strKey = "\(strKey)" + "\(word)"
                                    }
                                }
                            }
                            let dic = NSMutableDictionary()
                            dic.setValue("\(strKey)", forKey: "key")
                            dic.setValue("\(strValue)", forKey: "value")
                            arrTmpReport.add(dic)
                            
                            /*let arrKeyValue = strKeyValue.components(separatedBy: ":")
                             if arrKeyValue.count == 2
                             {
                             let dic = NSMutableDictionary()
                             dic.setValue(arrKeyValue[0], forKey: "key")
                             dic.setValue(arrKeyValue[1], forKey: "value")
                             self.arrDeliveryTicketData.add(dic)
                             }*/
                        }
                    }
                    arrTicket.add(arrTmpReport)
                }
            }
            
            print(arrTicket)
            for tmpArrTicketPacketSingle in arrTicket
            {
                let arrTicketPacketSingle = tmpArrTicketPacketSingle as! NSMutableArray
                let dicTicket = NSMutableDictionary()
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "trailer number") != nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "trailer_number")
                        break
                    }
                }
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "product name") != nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "product_name")
                        break
                    }
                }
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "delivery") != nil && strKey.lowercased().range(of: "delivery number") == nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "delivery")
                        break
                    }
                }
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "units") != nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "units")
                        break
                    }
                }
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "date") != nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "date")
                        break
                    }
                }
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "time") != nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "time")
                        break
                    }
                }
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "delivery number") != nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "delivery_number")
                        break
                    }
                }
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "accumulated total") != nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "accumulated_total")
                        break
                    }
                }
                
                for dic in arrTicketPacketSingle
                {
                    let dicValue = dic as? NSDictionary ?? NSDictionary()
                    let strKey = "\(dicValue.value(forKey: "key") ?? "")"
                    if strKey.lowercased().range(of: "issue") != nil
                    {
                        dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "error")
                        break
                    }
                }
                
                arrFinalTripReports.add(dicTicket)
            }
        }
        return arrFinalTripReports
    }
    
    
    //MARK:- RDT COMMAND
    func ConvertArduinoRDTCommandToDicationary() -> NSMutableDictionary {
        
        let arrTicket = NSMutableArray()
        var strNewToOutput = self
        print(strNewToOutput)
        let arr = strNewToOutput.components(separatedBy: "METER DELIVERY TICKET")
        if arr.count > 1
        {
            strNewToOutput = arr[1]
            strNewToOutput = strNewToOutput.replacingOccurrences(of: ": \n\r", with: ": ")
            strNewToOutput = strNewToOutput.replacingOccurrences(of: ":\n\r", with: ": ")
            let arrNew = NSMutableArray.init(array: strNewToOutput.components(separatedBy: "\n\r"))
            arrNew.remove("")
            print(arrNew)
            
            for keyValue in arrNew
            {
                let strKeyValue = "\(keyValue)"
                if strKeyValue.contains(":")
                {
                    var strKey = ""
                    var strValue = ""
                    var isSepratorFound = false
                    var foundCharInKey = false
                    var foundCharInValue = false
                    
                    for word in strKeyValue
                    {
                        if isSepratorFound
                        {
                            if word == " " && !foundCharInValue
                            {
                                
                            }
                            else
                            {
                                foundCharInValue = true
                                strValue = "\(strValue)" + "\(word)"
                            }
                        }
                        else
                        {
                            if word == ":"
                            {
                                isSepratorFound = true
                                continue
                            }
                            if word == " " && !foundCharInKey
                            {
                                
                            }
                            else
                            {
                                foundCharInKey = true
                                strKey = "\(strKey)" + "\(word)"
                            }
                        }
                    }
                    let dic = NSMutableDictionary()
                    dic.setValue("\(strKey)", forKey: "key")
                    dic.setValue("\(strValue)", forKey: "value")
                    arrTicket.add(dic)
                    
                    /*let arrKeyValue = strKeyValue.components(separatedBy: ":")
                     if arrKeyValue.count == 2
                     {
                     let dic = NSMutableDictionary()
                     dic.setValue(arrKeyValue[0], forKey: "key")
                     dic.setValue(arrKeyValue[1], forKey: "value")
                     self.arrDeliveryTicketData.add(dic)
                     }*/
                }
            }
            print(arrTicket)
        }
        
        
        
        
        let dicTicket = NSMutableDictionary()
        
        for dic in arrTicket
        {
            let dicValue = dic as? NSDictionary ?? NSDictionary()
            let strKey = "\(dicValue.value(forKey: "key") ?? "")"
            if strKey.lowercased().range(of: "trailer number") != nil
            {
                dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "trailer_number")
                break
            }
        }
        
        for dic in arrTicket
        {
            let dicValue = dic as? NSDictionary ?? NSDictionary()
            let strKey = "\(dicValue.value(forKey: "key") ?? "")"
            if strKey.lowercased().range(of: "product name") != nil
            {
                dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "product_name")
                break
            }
        }
        
        for dic in arrTicket
        {
            let dicValue = dic as? NSDictionary ?? NSDictionary()
            let strKey = "\(dicValue.value(forKey: "key") ?? "")"
            if strKey.lowercased().range(of: "delivery") != nil && strKey.lowercased().range(of: "delivery number") == nil
            {
                dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "delivery")
                break
            }
        }
        
        for dic in arrTicket
        {
            let dicValue = dic as? NSDictionary ?? NSDictionary()
            let strKey = "\(dicValue.value(forKey: "key") ?? "")"
            if strKey.lowercased().range(of: "units") != nil
            {
                dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "units")
                break
            }
        }
        
        for dic in arrTicket
        {
            let dicValue = dic as? NSDictionary ?? NSDictionary()
            let strKey = "\(dicValue.value(forKey: "key") ?? "")"
            if strKey.lowercased().range(of: "date") != nil
            {
                dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "date")
                break
            }
        }
        
        for dic in arrTicket
        {
            let dicValue = dic as? NSDictionary ?? NSDictionary()
            let strKey = "\(dicValue.value(forKey: "key") ?? "")"
            if strKey.lowercased().range(of: "time") != nil
            {
                dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "time")
                break
            }
        }
        
        for dic in arrTicket
        {
            let dicValue = dic as? NSDictionary ?? NSDictionary()
            let strKey = "\(dicValue.value(forKey: "key") ?? "")"
            if strKey.lowercased().range(of: "delivery number") != nil
            {
                dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "delivery_number")
                break
            }
        }
        
        for dic in arrTicket
        {
            let dicValue = dic as? NSDictionary ?? NSDictionary()
            let strKey = "\(dicValue.value(forKey: "key") ?? "")"
            if strKey.lowercased().range(of: "accumulated total") != nil
            {
                dicTicket.setValue("\(dicValue.value(forKey: "value") ?? "-")", forKey: "accumulated_total")
                break
            }
        }
        
        return dicTicket
    }
    
    
    //MARK:- AA Monitor Delivery COMMAND
    func ConvertArduinoAAMonitoringCommandToDicationary() -> NSMutableDictionary {
        
        let dicOfKeyValue = NSMutableDictionary()
        var strNewToOutput = self
        strNewToOutput = strNewToOutput.replacingOccurrences(of: "AA\nAA\n", with: "\n\r")
        var arr = strNewToOutput.components(separatedBy: "\n\r")
        if arr.count > 1
        {
            arr.removeFirst()
            arr.removeLast()
        }
        else
        {
            return dicOfKeyValue
        }
        let strResponse = arr.last
        let arr2 = strResponse?.components(separatedBy: "=")
        if arr2?.count == 6
        {
            //let result1 = arr2?[0].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
            let result2 = arr2?[1].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.-").inverted)
            let result3 = arr2?[2].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.-").inverted)
            let result4 = arr2?[3].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.-").inverted)
            let result5 = arr2?[4].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.-").inverted)
            let result6 = arr2?[5].trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.-").inverted)
            
            dicOfKeyValue.setValue("\(result2 ?? "0")", forKey: "R")
            dicOfKeyValue.setValue("\(result3 ?? "0")", forKey: "T")
            dicOfKeyValue.setValue("\(result4 ?? "0")", forKey: "GT")
            dicOfKeyValue.setValue("\(result5 ?? "0")", forKey: "T(K)")
            dicOfKeyValue.setValue("\(result6 ?? "0")", forKey: "P(psig)")
            
            let tUnit = arr2![3]
            if tUnit.contains("K")
            {
                dicOfKeyValue.setValue("Kelvin", forKey: "tUnit")
            }
            else if tUnit.contains("F")
            {
                dicOfKeyValue.setValue("Fahrenheit", forKey: "tUnit")
            }
            else if tUnit.contains("C")
            {
                dicOfKeyValue.setValue("Centigrade", forKey: "tUnit")
            }

            let pUnit = arr2![4]
            if pUnit.contains("psia")
            {
                dicOfKeyValue.setValue("psia", forKey: "pUnit")
            }
            else if pUnit.contains("psig")
            {
                dicOfKeyValue.setValue("psig", forKey: "pUnit")
            }
            else if pUnit.contains("barA")
            {
                dicOfKeyValue.setValue("bar-a", forKey: "pUnit")
            }
            else if pUnit.contains("barG")
            {
                dicOfKeyValue.setValue("bar-g", forKey: "pUnit")
            }
            
            print(dicOfKeyValue)
        }
        return dicOfKeyValue
        
    }
    
    
    //MARK:- REF Monitor Delivery COMMAND
    func ConvertArduinoREFMonitoringCommandToDicationary() -> String {
        
        var strRefranceCondition = ""
        var strNewToOutput = self
        let arr = strNewToOutput.components(separatedBy: "command == REF")
        if arr.count == 2
        {
            strNewToOutput = arr[1]
            strNewToOutput = strNewToOutput.replacingOccurrences(of: "\n\r", with: "")
            strNewToOutput = strNewToOutput.replacingOccurrences(of: " ", with: "")
            let arrTmp = strNewToOutput.components(separatedBy: "=")
            if arrTmp.count == 2
            {
                strRefranceCondition = "\(arrTmp[1])"
            }
        }
        return strRefranceCondition
        
    }
    
    
    //MARK:- GAS Monitor Delivery COMMAND
    func ConvertArduinoGASMonitoringCommandToDicationary() -> String {
        
        var strFluidType = ""
        var strNewToOutput = self
        let arr = strNewToOutput.components(separatedBy: "command == GAS")
        if arr.count == 2
        {
            strNewToOutput = arr[1]
            strNewToOutput = strNewToOutput.replacingOccurrences(of: "\n\r", with: "")
            strNewToOutput = strNewToOutput.replacingOccurrences(of: "\r\n", with: "")
            strNewToOutput = strNewToOutput.replacingOccurrences(of: " ", with: "")
            let arrTmp = strNewToOutput.components(separatedBy: "=")
            if arrTmp.count == 2
            {
                strFluidType = "\(arrTmp[1])"
            }
        }
        return strFluidType
        
    }
    
    func ConvertArduinoDLUMonitoringCommandToDicationary() -> String {
        
        var strFluidType = ""
        var strNewToOutput = self
        let arr = strNewToOutput.components(separatedBy: "command == DLU")
        if arr.count == 2
        {
            strNewToOutput = arr[1]
            strNewToOutput = strNewToOutput.replacingOccurrences(of: "\n\r", with: "")
            strNewToOutput = strNewToOutput.replacingOccurrences(of: "\r\n", with: "")
            strNewToOutput = strNewToOutput.replacingOccurrences(of: " ", with: "")
            let arrTmp = strNewToOutput.components(separatedBy: "=")
            if arrTmp.count == 2
            {
                strFluidType = "\(arrTmp[1])"
            }
        }
        return strFluidType
        
    }
    
    /// Error, Message string
    /// If Error :- (true, Error message)
    /// else :- (false,"")
    func ConvertArduino_US_CommandToErrorString() -> (Bool,String) { //Error,Message string
        var strNewToOutput = self
        if strNewToOutput.contains(find: "UNIT STATUS"){
            let arr = strNewToOutput.components(separatedBy: "=")
            if arr.count == 2
            {
                strNewToOutput = arr[1]
                strNewToOutput = strNewToOutput.trimmingCharacters(in: .whitespacesAndNewlines)
                return (false,strNewToOutput)
            }
            return (true,"Something Went Wrong when fetching value.")
        }else{
            return (true,"Something Went Wrong when fetching value.")
        }
    }

    //MARK:- CONFIGURATION COMMAND
    func ConvertArduinoDACommandToArray() -> [[String:Any]] {
        let arrTicket = NSMutableArray()
        var strNewToOutput = self
        print(strNewToOutput)
        let arr = strNewToOutput.components(separatedBy: "Software version")
        if arr.count > 1
        {
            strNewToOutput = arr[1]
            strNewToOutput = "Software version" + strNewToOutput
            strNewToOutput = strNewToOutput.replacingOccurrences(of: ": \n\r", with: ": ")
            strNewToOutput = strNewToOutput.replacingOccurrences(of: ":\n\r", with: ": ")
            let arrNew = NSMutableArray.init(array: strNewToOutput.components(separatedBy: "\n\r"))
            arrNew.remove("")
            print(arrNew)
            
            for keyValue in arrNew
            {
                let strKeyValue = "\(keyValue)"
                if strKeyValue.contains(":") && !strKeyValue.contains("date:")
                {
                    var strKey = ""
                    var strValue = ""
                    var isSepratorFound = false
                    var foundCharInKey = false
                    var foundCharInValue = false
                    
                    for word in strKeyValue
                    {
                        if isSepratorFound
                        {
                            if word == " " && !foundCharInValue
                            {
                                
                            }
                            else
                            {
                                foundCharInValue = true
                                strValue = "\(strValue)" + "\(word)"
                            }
                        }
                        else
                        {
                            if word == ":"
                            {
                                isSepratorFound = true
                                continue
                            }
                            if word == " " && !foundCharInKey
                            {
                                
                            }
                            else
                            {
                                foundCharInKey = true
                                strKey = "\(strKey)" + "\(word)"
                            }
                        }
                    }
                    let dic = NSMutableDictionary()
                    dic.setValue("\(strKey)", forKey: "key")
                    let result = self.findBlankValueFromtheValue(strString:strValue)
                    dic.setValue("\(result.1)", forKey: "value")
                    arrTicket.add(dic)
                    if result.0 {
                        let dic = NSMutableDictionary()
                        dic.setValue("\(result.2)", forKey: "key")
                        dic.setValue("\(result.3)", forKey: "value")
                        arrTicket.add(dic)
                    }
                }else {
                    print("\(strKeyValue)")
                    let arrNew = NSMutableArray.init(array: strKeyValue.components(separatedBy: "\r\n"))
                    arrNew.remove("")
                    
                    for keyValue in arrNew
                    {
                        let strKeyValue = "\(keyValue)"
                        if strKeyValue.contains("=")
                        {
                            var strKey = ""
                            var strValue = ""
                            var isSepratorFound = false
                            var foundCharInKey = false
                            var foundCharInValue = false
                            
                            for word in strKeyValue
                            {
                                if isSepratorFound
                                {
                                    if word == " " && !foundCharInValue
                                    {
                                        
                                    }
                                    else
                                    {
                                        foundCharInValue = true
                                        strValue = "\(strValue)" + "\(word)"
                                    }
                                }
                                else
                                {
                                    if word == "="
                                    {
                                        isSepratorFound = true
                                        continue
                                    }
                                    if word == " " && !foundCharInKey
                                    {
                                        
                                    }
                                    else
                                    {
                                        foundCharInKey = true
                                        strKey = "\(strKey)" + "\(word)"
                                    }
                                }
                            }
                            if strKey.contains("   "){
                                let result = self.findNilValueKey(strString: strKey)
                                if result.0 != "" || result.1 != "" {
                                    let dic = NSMutableDictionary()
                                    dic.setValue(result.0, forKey: "key")
                                    dic.setValue("", forKey: "value")
                                    arrTicket.add(dic)
                                    
                                    let dic1 = NSMutableDictionary()
                                    dic1.setValue("\(result.1)", forKey: "key")
                                    dic1.setValue("\(self.findValueFromtheKeyValue(strString: strValue).0)", forKey: "value")
                                    arrTicket.add(dic1)
                                }
                            }else{
                                let dic = NSMutableDictionary()
                                dic.setValue("\(strKey)", forKey: "key")
                                dic.setValue("\(self.findValueFromtheKeyValue(strString: strValue).0)", forKey: "value")
                                arrTicket.add(dic)
                                
                            }
                            if self.findValueFromtheKeyValue(strString: strValue).1.contains("="){
                                let result = self.strSeparate_KeyAnd_Values(strString: self.findValueFromtheKeyValue(strString: strValue).1, strSeparater: "=")
                                let dic = NSMutableDictionary()
                                dic.setValue(result.0, forKey: "key")
                                dic.setValue(result.1, forKey: "value")
                                arrTicket.add(dic)
                            }else if self.findValueFromtheKeyValue(strString: strValue).1.contains("date:"){
                                let result = self.strSeparate_KeyAnd_Values(strString: self.findValueFromtheKeyValue(strString: strValue).1, strSeparater: "date:")
                                let dic = NSMutableDictionary()
                                dic.setValue(result.0, forKey: "key")
                                dic.setValue(result.1, forKey: "value")
                                arrTicket.add(dic)
                            }
                        }
                    }
                }
            }
            print(arrTicket)
            return arrTicket as! [[String : Any]]
        }
        return []
    }
    func findNilValueKey(strString:String) -> (String,String) {
        //"Fre48   K-factor[ 3] "
        let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "   ")
        return (arr.first ?? "",arr.count>1 ? arr[1] : "")
    }
    
    func findValueFromtheKeyValue(strString:String) -> (String,String) {
        //"54.859   K-factor[ 1] =  822.927 "
        let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "   ")
        return (arr.first ?? "",arr.count>1 ? arr[1] : "")
    }
    
    func strSeparate_KeyAnd_Values(strString:String,strSeparater:String) -> (String,String) {
        //"K-factor[ 1] =  822.927"
        let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: strSeparater)
        if arr.count > 1 && arr[1] != ""{
           //"   822.927date:  09/01/2010"
           return (arr.first ?? "",self.strErrorFixedValueDate(strString:arr[1]))
        }
        return (arr.first ?? "",arr.count>1 ? arr[1] : "")
    }
    func strErrorFixedValueDate(strString:String) -> (String) {
        //"   822.927date:  09/01/2010"
        //Possible cases
        //1.  ate:
        //2.  te:
        if let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:"date:") as? [String],arr.count > 1 {
            return (arr.first ?? "")
        }else if let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:"ate:") as? [String],arr.count > 1 {
            return (arr.first ?? "")
        }else if let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:"te:") as? [String],arr.count > 1 {
            return (arr.first ?? "")
        }else if let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:"e:") as? [String],arr.count > 1 {
            return (arr.first ?? "")
        }
        else if let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:":") as? [String],arr.count > 1 {
            return (arr.first ?? "")
        }
        return strString
    }
    
    /// Some introductory test that describes the purpose
    /// of the function.
    
    /**
     The function are useful for the find the key-value pair in the values
     - parameters:
        - strString: pass the value key of the "\n\rReference conditions: Temperature units:  Fahrenheit\n\r"
     - Returns: Find the blank value in the strString and return approprite output.
        ex:- Reference conditions: ""
        Temperature units:  Fahrenheit
     */
    func findBlankValueFromtheValue(strString:String) -> (Bool,String,String,String) {
        //" Temperature units:  Fahrenheit"
        if strString.range(of: "Temperature units:") != nil {
            let arr = strString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":")
            if arr.count > 1 && arr[1] != ""{
                return (true,"",arr.first ?? "",arr.count>1 ? arr[1] : "")
            }
            return (true,"",arr.first ?? "",arr.count>1 ? arr[1] : "")
        }
        return (false,strString,"","") // normal values " gallons"
    }
    
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
