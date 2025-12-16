//
//  PayloadBuilderImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

@Suite("PayloadBuilderImp Tests")
struct PayloadBuilderImpTests {
    // MARK: - NO ERRORS
    @Test("Init should succeed")
    func testPayloadBuilder_init_succes() throws {
        
        // Arrange - given
        let encoder = JSONEncoder()
        let builder = PayloadBuilderImp(encoder: encoder)
        let modelData = MockTestModel(id: 1, name: "Rod")
        // Assert – Expect
        #expect(throws: Never.self) {
            // Act – Then
            _ = try builder.buildPayload(from: modelData)
        }
    }
    // MARK: - SUCCESS
   @Test("Shoul succesfully encode valid data")
    func testPayloadBuilder_validData() throws {
        // Arrange - given
        let encoder = JSONEncoder()
        let builder = PayloadBuilderImp(encoder: encoder)
        let modelData = MockTestModel(id: 1, name: "Rod")
        
        // Act – Then
        let data = try builder.buildPayload(from: modelData)

        // Assert – Expect
        #expect(data.count > 0)

        // Validate JSON decoding
        let decoded = try JSONDecoder().decode(MockTestModel.self, from: data)

        #expect(decoded.id == 1)
        #expect(decoded.name == "Rod")
    }
    // MARK: - CHECK snake_case is applied (initializer coverage)
    @Test("Initializer shoul apply convertToSnakeCase")
    func testPayloadBuilder_init_appliesConvertToSnakeCase() throws {
        // Arrange - given
        struct SnakeCaseModel: Codable {
            var firstName: String
            var lastName: String
        }
        let encoder = JSONEncoder()
        let builder = PayloadBuilderImp(encoder: encoder)
        let modelData = SnakeCaseModel(firstName: "Rod", lastName: "Gonza")
        // Act – Then
        let data = try builder.buildPayload(from: modelData)
        let jSONText = String(data: data, encoding: .utf8)!
        // Assert – Expect
        #expect(jSONText.contains("first_name"))
        #expect(jSONText.contains("last_name"))
    }
    //MARK: - ERROR route coverage (forces catch)
    @Test("Should throw NetworkingError.encodingFailed when encoding fails")
    func testPayloadBuilder_encodingFailed() {
        // Arrange - given
        let encoder = JSONEncoder()
        let builder = PayloadBuilderImp(encoder: encoder)
        let badData = MockBadEncodableModel()
        
        #expect {
            // Act - Then
            _ = try builder.buildPayload(from: badData)// forces catch
        } throws: { error in
            guard case NetworkingError.encodingFailed = error else {
                return false
            }
            return true
        }
        
    }
}
