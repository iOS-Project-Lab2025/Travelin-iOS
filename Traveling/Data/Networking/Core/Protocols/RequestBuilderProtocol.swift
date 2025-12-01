//
//  RequestBuilderProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

/// MARK: - RequestBuilder Protocol
///
/// Defines the interface for any component responsible for constructing
/// a `URLRequest` from an endpoint and an optional request body.
///
/// This abstraction supports flexible networking architectures where
/// request creation can be customized, replaced, or mocked.
///
/// ## Responsibilities
/// - Convert an `EndPointProtocol` definition into a valid `URLRequest`.
/// - Optionally handle serialization of request bodies.
///
/// ## Usage Example
/// ```swift
/// let request = try requestBuilder.buildRequest(from: UserEndpoint.getProfile, body: nil)
/// ```
///
/// ## Notes
/// - Implementations are expected to apply HTTP method, headers, and body.
/// - Frequently used by `NetworkServiceProtocol` to execute requests.
///
/// ## SeeAlso
/// - `RequestBuilderImp`
/// - `EndPointBuilderProtocol`
/// - `PayloadBuilderProtocol`
protocol RequestBuilderProtocol {

    /// Builds a `URLRequest` using the provided endpoint and optional body.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint describing method, path, headers, etc.
    ///   - body: Optional encodable payload.
    ///
    /// - Returns: A fully configured `URLRequest`.
    ///
    /// - Throws: Errors resulting from URL construction or body encoding.
    func buildRequest(from endpoint: EndPointProtocol, body: Encodable?) throws -> URLRequest
}

