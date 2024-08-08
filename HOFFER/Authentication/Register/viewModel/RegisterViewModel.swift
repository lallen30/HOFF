//
//  RegisterViewModel.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 JAME 214. All rights reserved.
//

import Foundation
final class RegisterViewModel {
    
    var registerResponceDict = RegisterModel([String:Any]())
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func registerUser(parameters: RegisterRequest) {
        self.eventHandler?(.loading)
     
        APIManager.shared.requestPost(
            modelType: RegisterModel.self, // response type
            type: APIEndPoint.singUp(param: parameters),
            header: false) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.registerResponceDict = data
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
    }
    
}

