//
//  MockTestModel.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation

struct MockTestModel: Codable {
    let id: Int
    let name: String
}
struct MockSimpleTestModel: Encodable {
    let userId: String
}
// Tipo que fuerza un error de codificación
struct MockBadEncodableModel: Encodable {
    func encode(to encoder: Encoder) throws {
        throw EncodingError.invalidValue(
            "BAD",
            EncodingError.Context(
                codingPath: [],
                debugDescription: "Forced failure for testing"
            )
        )
    }
}
