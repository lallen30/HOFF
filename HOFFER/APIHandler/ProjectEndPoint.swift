//
//  ProductEndPoint.swift
//  Youtube MVVM Products
//
//  Created by JAM-E-221 on 03/05/24.
//

import Foundation

enum APIEndPoint {
    case login (param : LoginRequest)
    case singUp (param : RegisterRequest)
    case updatePassword (param : updatePasswordRequest)
    case forgotPassword (param : ForgotRequest)
    case change_user_password (param : ChangePasswordRequest)
    case update_user (param : ProfileUpdateRequest)
    case logout
    case delete_user
    case get_user_profile
    case get_support_link
}

extension APIEndPoint: EndPointType {
    
    var baseURL: String {
        return "https://hoffer.betaplanets.com/api/v1/users/"
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var path: String {
        switch self {
            case .login:
                return "login"
            case .singUp:
                return "register"
            case .updatePassword:
                return "update_password"
            case .forgotPassword:
                return "forgot_password"
            case .logout:
                return "logout"
            case .delete_user:
                return "delete_user"
            case .get_user_profile:
                return "get_user_profile"
            case .change_user_password:
                return "change_user_password"
            case .update_user:
                return "update_user"
            case .get_support_link:
                return "get_support_link"
        }
    }
    
    var method: HTTPMethods {
        switch self {
            case .login:
                return .post
            case .singUp:
                return .post
            case .updatePassword:
                return .post
            case .forgotPassword:
                return .post
            case .logout:
                return .post
            case .delete_user:
                return .post
            case .get_user_profile:
                return .get
            case .change_user_password:
                return .post
            case .update_user:
                return .post
            case .get_support_link:
                return .get
        }
    }
    
    var body: Encodable? {
        switch self {
            case .login(let param):
                return param
            case .singUp(let param):
                return param
            case .logout:
                return nil
            case .updatePassword(let param):
                return param
            case .forgotPassword(let param):
                return param
            case .delete_user:
                return nil
            case .change_user_password(let param):
                return param
            case .get_user_profile:
                return nil
            case .update_user(let param):
                return param
            case .get_support_link:
                return nil
        }
        
    }
    
    var jsonBody: [String : Any]? {
        switch self {
            case .login:
                return nil
            case .singUp:
                return nil
            case .logout:
                return nil
            case .updatePassword:
                return nil
            case .forgotPassword:
                return nil
            case .delete_user:
                return nil
            case .get_user_profile:
                return nil
            case .change_user_password:
                return nil
            case .get_support_link:
                return nil
            case .update_user:
                return nil
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}

