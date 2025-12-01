//
//  NetworkServiceProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

/// MARK: - NetworkService Protocol
///
/// Defines the high-level interface for executing API requests within the networking layer.
/// This protocol abstracts away the details of:
/// - URLRequest construction
/// - network transport execution
/// - response validation
/// - JSON decoding
///
/// Implementations are responsible for orchestrating the full request–response cycle.
///
/// ## Responsibilities
/// - Build the request from an endpoint
/// - Send the network request using a client
/// - Validate the server response
/// - Decode the response body into a concrete `Decodable` type
///
/// ## Usage Example
/// ```swift
/// let service: NetworkServiceProtocol = NetworkServiceImp(...)
/// let result: User = try await service.execute(UserEndpoint.getProfile, responseType: User.self)
/// ```
///
/// ## Notes
/// - Higher-level layers such as repositories or use cases depend on this protocol.
/// - Supports any `Decodable` return type.
///
/// ## SeeAlso
/// - `NetworkServiceImp`
/// - `EndPointProtocol`
/// - `NetworkClientProtocol`
protocol NetworkServiceProtocol {

    /// Executes the given API endpoint and attempts to decode the response.
    ///
    /// - Parameters:
    ///   - endPoint: The endpoint defining method, path, headers, and query parameters.
    ///   - responseType: The expected decoded type of the response.
    ///   - body: Optional request body that will be encoded if provided.
    ///
    /// - Returns: A decoded instance of type `T`.
    /// - Throws: `NetworkingError` variants for networking, decoding, or request-building failures.
    func execute<T: Decodable>(
        _ endPoint: EndPointProtocol,
        responseType: T.Type,
        body: Encodable?
    ) async throws -> T
}

