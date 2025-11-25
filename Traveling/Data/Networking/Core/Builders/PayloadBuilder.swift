//
//  PayloadBuilders.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

struct PayloadBuilder: PayloadBuilderProtocol {
    func buildPayload<E: Encodable>(from model: E) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            return try encoder.encode(model)
        } catch {
            throw EncodingError.invalidValue(model, EncodingError.Context(codingPath: [], debugDescription: "Couldn't encode model"))
        }
    }
}
