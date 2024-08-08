//
//  updatePasswordViewModel.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation
final class updatePasswordViewModel {
    
    var updatePasswordResponceDict = updatePasswordModel([String:Any]())
   
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func updatePassword(parameters: updatePasswordRequest) {
        self.eventHandler?(.loading)
        
        APIManager.shared.requestPost(
            modelType: updatePasswordModel.self, // response type
            type: APIEndPoint.updatePassword(param: parameters),
            header: false) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.updatePasswordResponceDict = data
                    
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
    }
    
}

