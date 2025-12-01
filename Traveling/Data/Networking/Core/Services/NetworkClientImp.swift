//
//  NetworkClientImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 19-11-25.
//

import Foundation

/// MARK: - URLSession-based Network Client
///
/// `NetworkClientImp` is the concrete implementation of `NetworkClientProtocol`
/// that uses `URLSession` to perform network requests.
///
/// It acts as the lowest layer of networking, providing raw data without:
/// - request building,
/// - URL construction,
/// - payload encoding,
/// - response decoding.
///
/// These responsibilities belong to other components such as:
/// `RequestBuilderImp`, `EndPointBuilderImp`, and `NetworkServiceImp`.
///
/// ## Responsibilities
/// - Send network requests using `URLSession`
/// - Provide the raw response data and metadata
///
/// ## Usage Example
/// ```swift
/// let client = NetworkClientImp()
/// let (data, response) = try await client.execute(request)
/// ```
///
/// ## Notes
/// - Uses `URLSession.shared` by default but supports dependency injection for testing.
/// - Errors thrown are typically `URLError` or transport-level errors.
///
/// ## SeeAlso
/// - `NetworkClientProtocol`
/// - `NetworkServiceImp`
final class NetworkClientImp: NetworkClientProtocol {
    
    private let session: URLSession

    /// Initializes the client with a specific `URLSession`.
    ///
    /// - Parameter session: The URLSession instance to use. Defaults to `.shared`.
    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Executes a `URLRequest` and returns its raw response.
    ///
    /// - Parameter request: The request to perform.
    /// - Returns: A tuple containing the response `Data` and `URLResponse`.
    /// - Throws: Transport errors produced by `URLSession`.
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.session.data(for: request)
    }
}




