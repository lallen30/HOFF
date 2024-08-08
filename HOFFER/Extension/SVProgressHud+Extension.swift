//
//  SVProgressHud+Extension.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import UIKit
import SVProgressHUD


extension SVProgressHUD {
    
    public static func showDismissableError(with status: String) {
        let nc = NotificationCenter.default
        nc.addObserver(
            self, selector: #selector(hudTapped(_:)),
            name: NSNotification.Name.SVProgressHUDDidReceiveTouchEvent,
            object: nil
        )
        nc.addObserver(
            self, selector: #selector(hudDisappeared(_:)),
            name: NSNotification.Name.SVProgressHUDWillDisappear,
            object: nil
        )
        SVProgressHUD.showError(withStatus: status)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    @objc
    private static func hudTapped(_ notification: Notification) {
        SVProgressHUD.dismiss()
        SVProgressHUD.setDefaultMaskType(.none)
    }
    
    @objc
    private static func hudDisappeared(_ notification: Notification) {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name.SVProgressHUDDidReceiveTouchEvent, object: nil)
        nc.removeObserver(self, name: NSNotification.Name.SVProgressHUDWillDisappear, object: nil)
        SVProgressHUD.setDefaultMaskType(.none)
    }
    
    
    public static func showDismissableSuccess(with status: String) {
        let nc = NotificationCenter.default
        nc.addObserver(
            self, selector: #selector(hudTapped(_:)),
            name: NSNotification.Name.SVProgressHUDDidReceiveTouchEvent,
            object: nil
        )
        nc.addObserver(
            self, selector: #selector(hudDisappeared(_:)),
            name: NSNotification.Name.SVProgressHUDWillDisappear,
            object: nil
        )
        SVProgressHUD.showSuccess(withStatus: status)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
}
