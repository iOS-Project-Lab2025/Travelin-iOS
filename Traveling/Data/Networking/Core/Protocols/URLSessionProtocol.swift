//
//  URLSessionProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionProtocol {}
