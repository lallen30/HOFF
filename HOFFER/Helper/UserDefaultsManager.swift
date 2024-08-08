//
//  UserDefaultsManager.swift
//  HOFFER
//
//  Created by JAM-E-214 on 25/04/24.
//  Copyright © 2024 Abdulkadir. All rights reserved.
//

import Foundation
class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() { }
    
        //MARK: - Set Value
    func setValue<T>(_ value: T, forKey key: UserDefaultKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
        // MARK: - Get value
    func value<T>(forKey key: UserDefaultKey) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
        // MARK: - Set model using enum key
    func setModel<T: Codable>(_ model: T, forKey key: UserDefaultKey) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(model)
            UserDefaults.standard.set(encodedData, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        } catch {
            print("Error encoding model: \(error)")
        }
    }
    
        // MARK: - Get model using enum key
    func getModel<T: Codable>(forKey key: UserDefaultKey) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key.rawValue) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: savedData)
                return model
            } catch {
                print("Error decoding model: \(error)")
            }
        }
        return nil
    }
    
    
        // MARK: - Remove model using enum key
    func remove(forKey key: UserDefaultKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
        // MARK: - Clear all values
    func clearAllValues() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
}

enum UserDefaultKey: String {
    case userDetail
    case userRoleId
    case isLoggedIn
    case token
    case user_email
    case username
    case records
    case userRole
    case userVideoResumeURL
}
