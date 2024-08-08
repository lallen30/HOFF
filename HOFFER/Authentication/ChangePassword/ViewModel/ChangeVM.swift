//
//  ChangeVM.swift
//  HOFFER
//
//  Created by JAM-E-221 on 02/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation


import Foundation
import UIKit

final class ChangeViewModel {
    
    var responseDict = ChangeModel([String:Any]())
    var requestType = ""
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func changePaswword(param : ChangePasswordRequest) {
        self.eventHandler?(.loading)
        APIManager.shared.requestPost(
            modelType: ChangeModel.self, // response type
            type: APIEndPoint.change_user_password(param: param),
            header: true) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.responseDict = data
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
    }
    
  
    
    
}
