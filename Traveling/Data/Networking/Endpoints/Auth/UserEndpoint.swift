//
//  UserEndpoint.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25 and Daniel Retamal on 24-11-25.
//

import Foundation

enum UserEndpoint: EndPointProtocol {
    case login(email: String, password: String)
    case refresh(token: String)
    case me

    var path: String {
        switch self {
        case .login:
            return "/v1/auth/login"

        case .refresh:
            return "/v1/auth/refresh"

        case .me:
            return "/v1/auth/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .refresh:
            return .post

        default:
            return .get
        }
    }

    var queryItems: [URLQueryItem]? { nil }

    var headers: [String : String]? {
        switch method {
        case .post:
            return ["Content-Type": "application/json"]

        default:
            return nil
        }
    }
    
    // MARK: - Body Data
    // This property provides the body data for requests that need it
    var bodyData: Encodable? {
        switch self {
        case .login(let email, let password):
            return LoginRequest(email: email, password: password)
            
        case .refresh(let token):
            return RefreshTokenRequest(refreshToken: token)
            
        case .me:
            return nil
        }
    }
}

// MARK: - Request Models
struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}
