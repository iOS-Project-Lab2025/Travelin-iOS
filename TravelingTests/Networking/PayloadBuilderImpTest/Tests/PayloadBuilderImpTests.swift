//
//  PayloadBuilderImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating the behavior of `PayloadBuilderImp`.
///
/// These tests ensure that:
/// - The payload builder initializes correctly
/// - Valid encodable models are successfully encoded into JSON
/// - The encoder applies snake_case key conversion
/// - Encoding failures are correctly mapped to `NetworkingError.encodingFailed`
@Suite("PayloadBuilderImp Tests")
struct PayloadBuilderImpTests {

    // MARK: - No Error Scenarios

    /// Verifies that the payload builder initializes successfully
    /// and does not throw when encoding valid data.
    @Test("Init should succeed")
    func testPayloadBuilder_init_succes() throws {
        
        // Arrange
        let encoder = JSONEncoder()
        let builder = PayloadBuilderImp(encoder: encoder)
        let modelData = MockTestModel(id: 1, name: "Rod")

        // Assert
        #expect(throws: Never.self) {
            // Act
            _ = try builder.buildPayload(from: modelData)
        }
    }

    // MARK: - Success Scenarios

    /// Verifies that valid encodable data is successfully
    /// encoded into a non-empty JSON payload.
    @Test("Shoul succesfully encode valid data")
    func testPayloadBuilder_validData() throws {
        // Arrange
        let encoder = JSONEncoder()
        let builder = PayloadBuilderImp(encoder: encoder)
        let modelData = MockTestModel(id: 1, name: "Rod")
        
        // Act
        let data = try builder.buildPayload(from: modelData)

        // Assert
        #expect(data.count > 0)

        // Validate JSON decoding
        let decoded = try JSONDecoder().decode(MockTestModel.self, from: data)

        #expect(decoded.id == 1)
        #expect(decoded.name == "Rod")
    }

    // MARK: - Snake Case Encoding

    /// Verifies that the payload builder applies
    /// `convertToSnakeCase` key encoding strategy.
    @Test("Initializer shoul apply convertToSnakeCase")
    func testPayloadBuilder_init_appliesConvertToSnakeCase() throws {
        // Arrange
        struct SnakeCaseModel: Codable {
            var firstName: String
            var lastName: String
        }

        let encoder = JSONEncoder()
        let builder = PayloadBuilderImp(encoder: encoder)
        let modelData = SnakeCaseModel(firstName: "Rod", lastName: "Gonza")

        // Act
        let data = try builder.buildPayload(from: modelData)
        let jSONText = String(data: data, encoding: .utf8)!

        // Assert
        #expect(jSONText.contains("first_name"))
        #expect(jSONText.contains("last_name"))
    }

    // MARK: - Error Handling

    /// Verifies that encoding failures are mapped
    /// to `NetworkingError.encodingFailed`.
    @Test("Should throw NetworkingError.encodingFailed when encoding fails")
    func testPayloadBuilder_encodingFailed() {
        // Arrange
        let encoder = JSONEncoder()
        let builder = PayloadBuilderImp(encoder: encoder)
        let badData = MockBadEncodableModel()
        
        // Assert
        #expect {
            // Act
            _ = try builder.buildPayload(from: badData)
        } throws: { error in
            guard case NetworkingError.encodingFailed = error else {
                return false
            }
            return true
        }
    }
}
