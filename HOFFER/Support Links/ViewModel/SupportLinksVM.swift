//
//  SupportLinksVM.swift
//  HOFFER
//
//  Created by JAM-E-221 on 03/05/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation
import Foundation
final class SupportLinksVM {
    
    var supportLinksDict = SupportModel([String:Any]())
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func getSupportlinks() {
        self.eventHandler?(.loading)
     
        APIManager.shared.requestPost(
            modelType: SupportModel.self, // response type
            type: APIEndPoint.get_support_link,
            header: true) { result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let data):
                    print("Result >>>>>> \(result)")
                    print("Data >>>>>> \(data)")
                    self.supportLinksDict = data
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                self.eventHandler?(.error(error))
                    print(error)
                }
                
            }
    }
    
}

