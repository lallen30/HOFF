//
//  ProfileViewModel.swift
//  HOFFER
//
//  Created by JAM-E-221 on 02/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation


final class ProfileViewModel {
    
    var profileresponseDict = UserProfileModel([String:Any]())
    var requestType = ""
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func updateProfile(param : ProfileUpdateRequest) {
        self.eventHandler?(.loading)
        APIManager.shared.requestPost(
            modelType: UserProfileModel.self, // response type
            type: APIEndPoint.update_user(param: param),
            header: true) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.profileresponseDict = data
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
    }
    
  
    
    
}
