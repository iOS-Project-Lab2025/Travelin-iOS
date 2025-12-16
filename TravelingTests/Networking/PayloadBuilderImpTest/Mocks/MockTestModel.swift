//
//  MockTestModel.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation

/// Mock model used for testing JSON encoding and decoding.
///
/// This model represents a simple, valid payload
/// that can be encoded and decoded without errors.
/// It is commonly used in payload and networking tests.
struct MockTestModel: Codable {

    /// Identifier field used in test payloads.
    let id: Int

    /// Name field used in test payloads.
    let name: String
}

/// Mock model used for testing simple encoding scenarios.
///
/// This type is intentionally minimal and only conforms
/// to `Encodable` to validate payload creation logic.
struct MockSimpleTestModel: Encodable {

    /// User identifier used in encoding tests.
    let userId: String
}

/// Mock model designed to intentionally fail during encoding.
///
/// This type forces an encoding error by throwing
/// `EncodingError.invalidValue` inside `encode(to:)`.
///
/// It is used to validate error handling paths,
/// specifically mapping encoding failures to domain errors.
struct MockBadEncodableModel: Encodable {

    /// Forces an encoding failure when encoding is attempted.
    ///
    /// - Parameter encoder: The encoder attempting to encode this model.
    /// - Throws: `EncodingError.invalidValue` to simulate a failure.
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
