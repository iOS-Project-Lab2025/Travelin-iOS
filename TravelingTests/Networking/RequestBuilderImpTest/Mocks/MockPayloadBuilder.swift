//
//  MockPayloadBuilder.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation
@testable import Traveling

// MARK: - Mock PayloadBuilder

/// Mock implementation of `PayloadBuilderProtocol` used for unit testing.
///
/// This mock allows tests to:
/// - Capture the model passed for encoding
/// - Return predefined payload data
/// - Simulate encoding failures by throwing errors
///
/// The implementation is intentionally lightweight to ensure
/// tests focus on request-building and error-handling logic.
final class MockPayloadBuilder: PayloadBuilderProtocol {

    /// Data to be returned when building a payload.
    var returnedData: Data?

    /// Captures the model passed to `buildPayload(from:)`
    /// for later verification in tests.
    var capturedModel: Encodable?

    /// Optional error to be thrown instead of returning data.
    var thrownError: Error?

    /// Simulates payload encoding behavior.
    ///
    /// - Parameter model: The encodable model to be converted into payload data.
    /// - Returns: Encoded `Data` for the request body.
    /// - Throws: The predefined `thrownError`, if set.
    func buildPayload<E>(from model: E) throws -> Data where E: Encodable {
        capturedModel = model
        if let error = thrownError { throw error }
        return returnedData ?? Data([9, 9, 9])
    }
}
