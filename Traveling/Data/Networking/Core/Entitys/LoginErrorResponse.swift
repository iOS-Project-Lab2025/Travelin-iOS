//
//  LoginErrorResponse.swift
//  Traveling
//
//  Created by Ivan Pereira on 15-12-25.
//

import Foundation

struct LoginErrorResponse: Decodable {
    let errors: [APIError]

    struct APIError: Decodable {
        let status: Int
        let code: Int
        let title: String
        let detail: String
    }
}
