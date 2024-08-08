//
//  SettingViewModel.swift
//  HOFFER
//
//  Created by JAM-E-221 on 01/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//


import Foundation
import UIKit

final class SettingViewModel {
    
    var userProfileDict = UserProfileModel([String:Any]())
    var deleteResponceDict = DeleteModel([String:Any]())
    var settingResponceDict = SettingModel([String:Any]())
    var requestType = ""
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func logout() {
        self.eventHandler?(.loading)
        APIManager.shared.requestPost(
            modelType: SettingModel.self, // response type
            type: APIEndPoint.logout,
            header: true) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.settingResponceDict = data
                    self.requestType = "logout"
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
    }
    
    func getUserProfile() {
        self.eventHandler?(.loading)
        APIManager.shared.requestPost(
            modelType: UserProfileModel.self, // response type
            type: APIEndPoint.get_user_profile,
            header: true) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.userProfileDict = data
                    self.requestType = "userProfile"
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
    }
    
    func deleteAccount() {
        self.eventHandler?(.loading)
        APIManager.shared.requestPost(
            modelType: DeleteModel.self, // response type
            type: APIEndPoint.delete_user,
            header: true) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.deleteResponceDict = data
                    self.requestType = "deleteAccount"
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
        
    }
    
}
