//
//  LoginViewModel.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 JAM-E-214. All rights reserved.
//

import Foundation
import UIKit

final class LoginViewModel {
    
    var loginResponceDict = LoginModel([String:Any]())
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func logIn(parameters: LoginRequest) {
        self.eventHandler?(.loading)
        APIManager.shared.requestPost(
            modelType: LoginModel.self, // response type
            type: APIEndPoint.login(param: parameters),
            header: false) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.loginResponceDict = data
                    
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
        
    }
}

