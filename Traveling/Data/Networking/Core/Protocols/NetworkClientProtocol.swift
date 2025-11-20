//
//  NetworkClientProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

protocol NetworkClientProtocol {
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse)
}
