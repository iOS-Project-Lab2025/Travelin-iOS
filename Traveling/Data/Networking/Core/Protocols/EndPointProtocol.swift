//
//  EndPoint.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

protocol EndPointProtocol {
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

extension EndPointProtocol {
    var queryItems: [URLQueryItem]? { nil }
        // Default: ningún header obligatorio
    var headers: [String: String]? { nil }
}
