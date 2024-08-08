//
//  ParametresRequest.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation

//MARK: - Login





func checkForNilAndNull(dictionary:[String:Any],key:String) -> Bool
{
    if dictionary[key] == nil || dictionary[key] is NSNull{
        return false
    }
    return true
}
