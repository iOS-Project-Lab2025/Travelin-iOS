//
//  LoginResponse.swift
//  Traveling
//
//  Created by Ivan Pereira on 15-12-25.
//

import Foundation

struct LoginResponse: Codable {
    let data: TokenData

    struct TokenData: Codable {
        let user: UserInfo
        let accessToken: String
        let refreshToken: String?

        struct UserInfo: Codable {
            let id: Int
            let email: String
            let firstName: String?
            let lastName: String?
        }
    }
}
