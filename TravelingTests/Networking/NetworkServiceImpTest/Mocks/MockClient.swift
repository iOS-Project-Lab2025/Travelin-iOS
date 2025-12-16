//
//  MockClient.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

@testable import Traveling
import Foundation

/// Mock implementation of `NetworkClientProtocol` used for testing.
///
/// This mock allows tests to simulate network execution results
/// without performing real network requests.
///
/// It supports:
/// - Returning predefined data and responses
/// - Throwing predefined errors
///
/// The behavior is intentionally simple to ensure tests
/// focus on higher-level networking and service logic.
final class MockClient: NetworkClientProtocol {

    /// Data to be returned when executing a request.
    var returnedData: Data?

    /// URL response to be returned when executing a request.
    var returnedResponse: URLResponse?

    /// Optional error to be thrown instead of returning data and response.
    var thrownError: Error?

    /// Simulates the execution of a network request.
    ///
    /// - Parameter request: The URL request to be executed.
    /// - Returns: A tuple containing `Data` and `URLResponse`.
    /// - Throws: The predefined `thrownError`, if set.
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = thrownError { throw error }
        return (returnedData ?? Data(), returnedResponse ?? URLResponse())
    }
}
