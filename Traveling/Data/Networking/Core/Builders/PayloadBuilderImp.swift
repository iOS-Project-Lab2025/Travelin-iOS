//
//  PayloadBuilders.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

struct PayloadBuilderImp: PayloadBuilderProtocol {
    
    private let encoder: JSONEncoder
    
    init(encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = encoder
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    func buildPayload<E: Encodable>(from model: E) throws -> Data {
        do {
            let data = try self.encoder.encode(model)
            return data
        } catch let error as EncodingError {
            throw NetworkingError.encodingFailed(error)
        }
    }
}
