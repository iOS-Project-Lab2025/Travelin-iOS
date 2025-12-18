//
//  MockURLSession.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation
@testable import Traveling

/// Mock implementation of `URLSessionProtocol` used for unit testing.
///
/// This class allows tests to simulate network behavior without
/// performing real HTTP requests.
///
/// It supports:
/// - Returning predefined data and responses
/// - Throwing predefined errors
/// - Tracking whether the `data(for:)` method was called
final class MockURLSession: URLSessionProtocol {

    /// Mocked data to be returned by the session.
    var mockData: Data?

    /// Mocked URL response to be returned by the session.
    var mockResponse: URLResponse?

    /// Mocked error to be thrown instead of returning data.
    var mockError: Error?

    /// Flag indicating whether `data(for:)` was invoked.
    var dataWasCalled = false
    
    /// Simulates the behavior of `URLSession.data(for:)`.
    ///
    /// - Parameter request: The URL request to be executed.
    /// - Returns: A tuple containing `Data` and `URLResponse`.
    /// - Throws:
    ///   - The predefined `mockError`, if set.
    ///   - `URLError.unknown` if no mock data or response is provided.
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataWasCalled = true
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData, let response = mockResponse else {
            throw URLError(.unknown)
        }
        
        return (data, response)
    }
}

