//
//  NetworkClientProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

// MARK: - NetworkClient Protocol
///
/// Defines the low-level contract for executing raw `URLRequest` objects.
/// This protocol abstracts the actual networking mechanism (e.g. `URLSession`)
/// allowing higher layers such as `NetworkServiceImp` to remain testable and decoupled.
///
/// ## Responsibilities
/// - Execute a fully constructed `URLRequest`
/// - Return the raw `Data` and `URLResponse` from the network operation
///
/// ## Usage Example
/// ```swift
/// let client: NetworkClientProtocol = NetworkClientImp()
/// let (data, response) = try await client.execute(request)
/// ```
///
/// ## Notes
/// - Does not handle retries, interceptors, or decoding.
///   Those responsibilities belong to higher-level services.
/// - Ideal for mocking in unit tests.
///
/// ## SeeAlso
/// - `NetworkClientImp`
/// - `NetworkServiceProtocol`
protocol NetworkClientProtocol {

    /// Executes the given URLRequest asynchronously.
    ///
    /// - Parameter request: The request to be executed.
    /// - Returns: A tuple containing raw response `Data` and `URLResponse`.
    /// - Throws: Any networking error thrown by the underlying transport layer.
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse)
}
