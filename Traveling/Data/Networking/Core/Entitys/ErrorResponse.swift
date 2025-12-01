//
//  ErrorResponse.swift
//  TestNetworking
//
//  Created by Rodolfo Gonzalez on 30-11-25.
//

import Foundation

// MARK: - Error Response Model
struct ErrorResponse: Decodable {
    let message: String
    let code: String?
    let details: [String: String]?
}
