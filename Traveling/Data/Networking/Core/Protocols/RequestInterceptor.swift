//
//  RequestInterceptor.swift
//  Traveling
//  Created by Daniel Retamal on 18-11-25.
//

import Foundation

/// Enum to decide what to do after an error
enum RetryResult {
    case retry              // Retry the request
    case doNotRetry         // Return the original error
    case doNotRetryWithError(Error) // Return a new error (e.g., logout)
}

protocol RequestInterceptor {
    /// Modifies the request before sending it (e.g., add headers)
    func adapt(_ request: URLRequest) async -> URLRequest
    
    /// Decides what to do if the request fails (e.g., if it's 401, refresh and retry)
    func shouldRetry(_ request: URLRequest, with error: Error, response: HTTPURLResponse?) async -> RetryResult
}
