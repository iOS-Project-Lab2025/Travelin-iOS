//
//  NetworkServiceProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

protocol NetworkServiceProtocol {
    func execute<T: Decodable, E: Encodable>(
        _ endPoint: EndPoint,
        responseType: T.Type,
        body: E? 
    ) async throws -> T
}
