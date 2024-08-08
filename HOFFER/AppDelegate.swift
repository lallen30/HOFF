//
//  AppDelegate.swift
//  HOFFER
//
//  Created by SiliconMac on 25/07/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController:UINavigationController!
    var isBTOffline = false


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Preferences.registerDefaults()
       
        /*let errorMsg = Int32(2345371).binaryDescription
        print(errorMsg)
        var strError : [String] = []
        for (index, char) in errorMsg.enumerated() {
            if char == Character("1"){
                //print("Errors :- \(arrICEErrors[index])")
                strError.append(arrICEErrors[index])
            }
        }
        print("- \(strError.joined(separator: ".\n- "))")
        //Singleton().showErrorWithSingleButton(strMessage: "- \(strError.joined(separator: ".\n- "))")
        */
        //let strEncode = "REEKREEKQ29uZmlndXJhdGlvbiBQcmludG91dAoNMTEvMDUvMjAxODo6MDk6MDMKDSAgCg1Tb2Z0d2FyZSB2ZXJzaW9uOiAxLjA2MTMxOAoNU29mdHdhcmUgQ1JDOiAgQURCCg1SZWZlcmVuY2U6ICBOQlAgKDEgYXRtKQoNVGVtcGVyYXR1cmUgdW5pdHM6ICBLZWx2aW4KDURlZmF1bHQgdGVtcGVyYXR1cmU6ICAgMTExLjAKDVByZXNzdXJlIHVuaXRzOiAgcHNpZwoNRGVmYXVsdCBwcmVzc3VyZTogICAyMzUuMwoNRGVsaXZlcnkgdW5pdHM6ICBnYWxsb25zCg1Ub3RhbCBkZWNpbWFsIHBsYWNlczogICAwCg1GbHVpZCB0eXBlOiAgTElOCg1EaXNwbGF5IFQvTyAobWluKTogICAgMTAKDUNvbXBlbnNhdGlvbiBtZXRob2Q6Cg1URU1QRVJBVFVSRSAmIERFRkFVTFQgUFJFU1NVUkUKDVB1bXAgZGVsYXkgKG1pbik6ICAgMC4xCg1UcmFpbGVyIG51bWJlcjogIDExMTExCg1TZXJpYWwgbnVtYmVyOiAgICAgNDU2NzgKDU1ldGVyIHNpemUgKGluY2gpOiAgMS4wMAoNSy1mYWN0b3IgbWV0aG9kOiAgQXZlcmFnZSA9ICAgNTQuODU5ICAgSy1mYWN0b3JbIDFdID0gIDgyMi45MjcgDQpGcmVxdWVuY3lbIDJdID0gICA1NC44NzYgICBLLWZhY3RvclsgMl0gPSA2OTY5LjAwMCANCkZyZXF1ZW5jeVsgM10gPSAgIDk3LjM0OCAgIEstZmFjdG9yWyAzXSA9ICA4MjQuNDgxIA0KRnJlcXVlbmN5WyA0XSA9ICAxMzguNjI4ICAgSy1mYWN0b3JbIDRdID0gIDgyMy4xMjEgDQpGcmVxdWVuY3lbIDVdID0gIDgwMC4wMDAgICBLLWZhY3RvclsgNV0gPSAzMzMzLjAwMCANCkxhc3QgY2FsaWJyYXRpb24gZGF0ZTogIDA=".fromBase64()
        
        let dicInput = NSMutableDictionary()
        let strUUID = "\(UIDevice.current.identifierForVendor!.uuidString)"
        dicInput.setValue(strUUID, forKey: "user_id")
        UserDefaults.standard.setValue(dicInput, forKey: "userDetail")
        UserDefaults.standard.synchronize()
        
        // GETTING UPDATE DEVICE LIST FROM THE SERVER.
        Singleton.sharedSingleton.getDevicesList(successBlock: {
            print("Success")
        }) {
            print("Failier")
        }
        
        //let pLoginViewController = storyboard.instantiateViewController(withIdentifier: "ErrorOtpViewControllerID") as!ErrorOtpViewController
        if UserDefaults.accessToken == ""{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewViewController") as! LoginViewViewController
            self.navController = UINavigationController(rootViewController:vc)
            self.navController?.interactivePopGestureRecognizer?.isEnabled = false
            self.navController?.setNavigationBarHidden(true, animated: false)
            self.navController.isNavigationBarHidden = true
            self.window?.rootViewController = self.navController
            self.window?.makeKeyAndVisible()
            
        }
        IQKeyboardManager.shared.enable = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HOFFER")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension BinaryInteger {
    
    /// convert intger to binary with 4,8,16,... 32 bit
    ///
    ///     reference - https://stackoverflow.com/a/51882984/2910061
    /// description:-
    ///
    ///     UInt8(22).binaryDescription     // "0b00010110"
    ///     Int8(60).binaryDescription      // "0b00111100"
    ///     Int8(-60).binaryDescription     // "0b11000100"
    ///     Int16(255).binaryDescription    // "0b0000000011111111"
    ///     Int16(-255).binaryDescription   // "0b1111111100000001"
    ///     Int32(2359296).binaryDescription // "00000000001001000000000000000000"
    /// ---
    var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        for _ in (1...self.bitWidth) {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
        }
        return binaryString
    }
}
