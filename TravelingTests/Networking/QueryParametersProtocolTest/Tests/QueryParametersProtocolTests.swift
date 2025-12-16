//
//  QueryParametersProtocolTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating the behavior of `QueryParametersProtocol`.
///
/// These tests ensure that:
/// - Properties are correctly converted into `URLQueryItem` values
/// - Optional values are omitted when nil
/// - Arrays are serialized as comma-separated values
/// - Primitive types are converted to their string representations
/// - Edge cases and real-world scenarios are handled safely
@Suite("QueryParametersProtocol Tests")
struct QueryParametersProtocolTests {

    // MARK: - Core Behavior
    
    /// Verifies that all properties of a conforming type
    /// are converted into valid `URLQueryItem` instances.
    @Test("Converts properties to valid URLQueryItems")
    func convertsPropertiesToQueryItems() {
        struct Params: QueryParametersProtocol {
            let query: String
            let limit: Int
            let active: Bool
        }

        let params = Params(query: "coffee", limit: 10, active: true)
        let items = params.toQueryItems()

        // Verify correct number of query items and non-nil values
        #expect(items.count == 3)
        #expect(items.allSatisfy { $0.value != nil })
        
        // Verify that the query items can be used to build a valid URL
        var components = URLComponents(string: "https://api.example.com")!
        components.queryItems = items
        #expect(components.url != nil)
    }

    // MARK: - Optional Handling
    
    /// Verifies that optional properties
    /// are omitted from query items when they are `nil`.
    @Test("Omits nil optional values")
    func omitsNilValues() {
        struct Params: QueryParametersProtocol {
            let required: String
            let optional: String?
        }

        let params = Params(required: "present", optional: nil)
        let items = params.toQueryItems()

        #expect(items.count == 1)
        #expect(items.first?.value == "present")
    }
    
    /// Verifies that an empty query item list
    /// is returned when all properties are `nil`.
    @Test("Returns empty array when all values are nil")
    func returnsEmptyForAllNil() {
        struct Params: QueryParametersProtocol {
            let a: String?
            let b: Int?
        }

        let params = Params(a: nil, b: nil)
        
        #expect(params.toQueryItems().isEmpty)
    }

    // MARK: - Array Handling
    
    /// Verifies that array values
    /// are serialized as comma-separated strings.
    @Test("Serializes arrays as comma-separated values")
    func serializesArrays() {
        struct Params: QueryParametersProtocol {
            let tags: [String]
            let ids: [Int]
        }

        let params = Params(tags: ["swift", "ios"], ids: [1, 2, 3])
        let items = params.toQueryItems()

        #expect(items.count == 2)
        
        let tagsValue = items.first { $0.value?.contains(",") == true }
        #expect(tagsValue != nil)
        #expect(tagsValue?.value?.components(separatedBy: ",").count == 2)
    }
    
    /// Verifies that empty arrays
    /// are included as empty string values.
    @Test("Handles empty arrays")
    func handlesEmptyArrays() {
        struct Params: QueryParametersProtocol {
            let items: [String]
        }

        let params = Params(items: [])
        let items = params.toQueryItems()

        #expect(items.count == 1)
        #expect(items.first?.value == "")
    }
    
    /// Verifies that optional arrays
    /// are omitted when they are `nil`.
    @Test("Omits nil optional arrays")
    func omitsNilArrays() {
        struct Params: QueryParametersProtocol {
            let present: String
            let missing: [String]?
        }

        let params = Params(present: "here", missing: nil)
        
        #expect(params.toQueryItems().count == 1)
    }

    // MARK: - Type Conversion
    
    /// Verifies that supported primitive types
    /// are converted to their string representations.
    @Test("Converts various types to string representation")
    func convertsTypes() {
        struct Params: QueryParametersProtocol {
            let text: String
            let number: Int
            let decimal: Double
            let flag: Bool
        }

        let params = Params(text: "test", number: 42, decimal: 3.14, flag: true)
        let items = params.toQueryItems()

        #expect(items.count == 4)
        #expect(items.contains { $0.value == "test" })
        #expect(items.contains { $0.value == "42" })
        #expect(items.contains { $0.value == "3.14" })
        #expect(items.contains { $0.value == "true" })
    }
    
    /// Verifies that zero and false values
    /// are treated as valid values, not omitted.
    @Test("Includes zero and false values")
    func includesZeroAndFalse() {
        struct Params: QueryParametersProtocol {
            let count: Int
            let flag: Bool
        }

        let params = Params(count: 0, flag: false)
        let items = params.toQueryItems()

        #expect(items.count == 2)
        #expect(items.contains { $0.value == "0" })
        #expect(items.contains { $0.value == "false" })
    }

    // MARK: - String Handling
    
    /// Verifies that string values
    /// preserve whitespace and special characters.
    @Test("Preserves special characters and whitespace")
    func preservesStringContent() {
        struct Params: QueryParametersProtocol {
            let text: String
            let empty: String
        }

        let params = Params(text: "café & bar  ", empty: "")
        let items = params.toQueryItems()

        #expect(items.count == 2)
        #expect(items.contains { $0.value == "café & bar  " })
        #expect(items.contains { $0.value == "" })
    }

    // MARK: - CustomStringConvertible
    
    /// Verifies that values conforming to `CustomStringConvertible`
    /// use their `description` for serialization.
    @Test("Uses CustomStringConvertible description")
    func usesCustomDescription() {
        enum Status: String, CustomStringConvertible, Encodable {
            case active
            var description: String { "STATUS_\(rawValue)" }
        }

        struct Params: QueryParametersProtocol {
            let status: Status
            let categories: [Status]
        }

        let params = Params(status: .active, categories: [.active])
        let items = params.toQueryItems()

        #expect(items.contains { $0.value == "STATUS_active" })
        #expect(items.contains { $0.value?.contains("STATUS_active") == true })
    }

    // MARK: - Edge Cases
    
    /// Verifies that an empty struct
    /// produces no query items.
    @Test("Handles empty struct")
    func handlesEmptyStruct() {
        struct Empty: QueryParametersProtocol {}
        
        #expect(Empty().toQueryItems().isEmpty)
    }
    
    /// Verifies that complex types
    /// still produce a fallback string value.
    @Test("Provides fallback for complex types")
    func handlesFallback() {
        struct Custom: Encodable { let id: Int }
        struct Params: QueryParametersProtocol {
            let data: Custom
        }

        let items = Params(data: Custom(id: 42)).toQueryItems()

        #expect(items.count == 1)
        #expect(items.first?.value?.isEmpty == false)
    }

    // MARK: - Real-World Scenario
    
    /// Verifies that a realistic set of API parameters
    /// can be converted into a valid URL query string.
    @Test("Handles realistic API parameters")
    func handlesRealisticScenario() {
        enum Sort: String, CustomStringConvertible, Encodable {
            case date, rating
            var description: String { rawValue }
        }

        struct SearchRequest: QueryParametersProtocol {
            let query: String
            let categories: [String]?
            let minPrice: Double?
            let maxPrice: Double?
            let inStock: Bool
            let page: Int
            let sort: Sort?
        }

        let request = SearchRequest(
            query: "laptop",
            categories: ["electronics"],
            minPrice: 500.0,
            maxPrice: nil,
            inStock: true,
            page: 1,
            sort: .rating
        )

        let items = request.toQueryItems()
        
        var components = URLComponents(string: "https://api.shop.com/search")!
        components.queryItems = items
        
        guard let url = components.url else {
            #expect(Bool(false), "Should create valid URL")
            return
        }

        #expect(items.count == 6)
        #expect(url.absoluteString.contains("query="))
        #expect(url.absoluteString.contains("inStock=true"))
        #expect(url.absoluteString.contains("page=1"))
    }
}
