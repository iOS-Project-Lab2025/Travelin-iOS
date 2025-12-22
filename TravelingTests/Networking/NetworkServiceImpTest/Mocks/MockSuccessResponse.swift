//
//  MockSuccessResponse.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation

/// Mock response model used for testing successful network responses.
///
/// This type represents a minimal, predictable payload that can be:
/// - Decoded from JSON
/// - Compared for equality in assertions
///
/// It is intentionally simple to ensure tests focus on
/// networking and decoding behavior rather than domain complexity.
struct MockSuccessResponse: Codable, Equatable {

    /// Identifier returned by the mocked API response.
    let id: Int

    /// Name field returned by the mocked API response.
    let name: String
}
