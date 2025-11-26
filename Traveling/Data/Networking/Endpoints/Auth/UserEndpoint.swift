//
//  UserEndpoint.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

enum UserEndpoint: EndPointProtocol {
    case getUsers
    case getUser(id: Int)
    case login(email: String, password: String)
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
            
        case .getUser(let id):
            return "/users/\(id)"
            
        case .login:
            return "/auth/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUser:
            return .get
            
        case .login:
            return .post
        }
    }
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getUsers:
            return [URLQueryItem(name: "limit", value: "100")]
            
        default:
            return nil
        }
    }

    var headers: [String : String]? {
        switch method {
        case .post:
            return ["Content-Type": "application/json"]

        default:
            return nil
        }
    }
}
