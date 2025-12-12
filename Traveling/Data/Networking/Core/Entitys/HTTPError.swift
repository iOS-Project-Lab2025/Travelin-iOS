//
//  HTTPError.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

struct HTTPError: Error, Codable {
    var statusCode: Int = 0
    let message: String
    enum CodingKeys: String, CodingKey {
        case message = "error_message"
    }
}
