//
//  InterceptableNetworkClientProtocol.swift
//  Traveling
//
//  Created by Daniel Retamal on 20-11-25.
//

import Foundation

/// Protocol for network clients that support request/response interceptors.
/// This is typically used for authenticated requests that need automatic
/// token injection and refresh capabilities.
///
/// Unlike `NetworkClientProtocol` which returns the full `URLResponse`,
/// this protocol returns only `Data` since the interceptor handles
/// response analysis (status codes, headers, etc.) internally.
protocol InterceptableNetworkClientProtocol {
    /// Executes a network request with interceptor support.
    ///
    /// The implementation should:
    /// 1. Call `interceptor.adapt()` to modify the request (e.g., inject auth token)
    /// 2. Execute the request
    /// 3. If 401, call `interceptor.shouldRetry()` to handle token refresh
    /// 4. Retry if instructed by the interceptor
    ///
    /// - Parameter request: The URLRequest to execute
    /// - Returns: The response data
    /// - Throws: Network errors or interceptor errors
    func execute(_ request: URLRequest) async throws -> Data
}
