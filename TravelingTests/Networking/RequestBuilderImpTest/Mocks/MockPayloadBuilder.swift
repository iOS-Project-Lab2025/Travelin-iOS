//
//  MockPayloadBuilder.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation
@testable import Traveling

// MARK: - Mock PayloadBuilder
final class MockPayloadBuilder: PayloadBuilderProtocol {
    var returnedData: Data?
    var capturedModel: Encodable?
    var thrownError: Error?

    func buildPayload<E>(from model: E) throws -> Data where E : Encodable {
        capturedModel = model
        if let error = thrownError { throw error }
        return returnedData ?? Data([9, 9, 9])
    }
}
