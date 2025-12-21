//
//  URLSessionProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation

/// Abstraction over `URLSession` used to enable testability.
///
/// This protocol allows networking code to depend on an interface
/// rather than a concrete `URLSession` instance, making it possible
/// to inject mock implementations during unit testing.
///
/// It mirrors the subset of `URLSession` functionality required
/// by the networking layer.
protocol URLSessionProtocol {

    /// Executes a URL request asynchronously.
    ///
    /// - Parameter request: The `URLRequest` to be executed.
    /// - Returns: A tuple containing the response `Data` and `URLResponse`.
    /// - Throws: Any error produced during request execution.
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

/// Makes `URLSession` conform to `URLSessionProtocol`.
///
/// This allows the production networking code to use `URLSession`
/// transparently while still enabling dependency injection of
/// mock sessions in tests.
extension URLSession: URLSessionProtocol {}
