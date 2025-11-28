//
//  NetworkServiceProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

protocol NetworkServiceProtocol {
    func execute<T: Decodable>( _ endPoint: EndPointProtocol, responseType: T.Type, body: Encodable?) async throws -> T
}
