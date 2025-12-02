//
//  NetworkingError.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 27-11-25.
//

import Foundation

// MARK: - NetworkingError
///
/// Represents all possible errors that can occur within the networking layer.
/// This unified error model simplifies error handling throughout
/// URL building, request creation, execution, and response decoding.
///
/// ## Error Categories
/// - **EndPointBuilder Errors**: URL construction problems.
/// - **RequestBuilder Errors**: Failed request creation.
/// - **PayloadBuilder Errors**: JSON encoding failures.
/// - **NetworkClient Errors**: Transport or connectivity issues.
/// - **NetworkService Errors**: Response validation or decoding failures.
/// - **Repository Errors**: Propagated networking errors.
/// - **Unknown Errors**: Fallback for unclassified issues.
///
/// ## Usage Example
/// ```swift
/// do {
///     let response = try await networkService.execute(...)
/// } catch let err as NetworkingError {
///     print(err.errorDescription ?? "Unknown error")
/// }
/// ```
///
/// ## Notes
/// - Conforms to `Equatable` for unit testing.
/// - Provides meaningful debug messages through `LocalizedError`.
///
/// ## SeeAlso
/// - `ErrorResponse`
/// - `NetworkServiceProtocol`
/// - `RequestBuilderProtocol`
enum NetworkingError: Error, Equatable {

    // MARK: - EndPointBuilder Errors
    /// Indicates the URL is malformed or incomplete.
    case invalidURL(URLError)

    // MARK: - RequestBuilder Errors
    /// Failure while assembling the `URLRequest`.
    case requestBuildingFailed(String)

    // MARK: - PayloadBuilder Errors
    /// JSON encoding failure for the request body.
    case encodingFailed(Error)

    // MARK: - NetworkClient Errors
    /// No internet connectivity detected.
    case noConnection
    /// Server did not respond within timeout constraints.
    case timeout
    /// Transport-related error returned by the `URLSession`.
    case transportError(URLError)

    // MARK: - NetworkService Errors
    /// Server returned an HTTP error (4xx or 5xx).
    case serverError(code: Int, message: String? = nil)
    /// Failed to decode the server response.
    case decodingFailed(Error)
    /// Response contains an unsupported content-type.
    case invalidContentType
    /// Response body is unexpectedly empty.
    case emptyResponse

    // MARK: - Generic / Unknown Errors
    /// Fallback case for unclassified errors.
    case unknown(Error?)
}

// MARK: - Equatable Conformance
///
/// Enables pattern matching in tests or logic that compares error types.
extension NetworkingError {
    static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        switch (lhs, rhs) {

        case (.invalidURL(let lErr), .invalidURL(let rErr)):
            return lErr == rErr

        case (.noConnection, .noConnection):
            return true

        case (.timeout, .timeout):
            return true

        case (.invalidContentType, .invalidContentType):
            return true

        case (.emptyResponse, .emptyResponse):
            return true

        case (.requestBuildingFailed(let lMsg), .requestBuildingFailed(let rMsg)):
            return lMsg == rMsg

        case (.encodingFailed, .encodingFailed):
            return true

        case (.transportError(let lErr), .transportError(let rErr)):
            return lErr.code == rErr.code

        case (.serverError(let lCode, _), .serverError(let rCode, _)):
            return lCode == rCode

        case (.decodingFailed, .decodingFailed):
            return true

        case (.unknown, .unknown):
            return true

        default:
            return false
        }
    }
}

// MARK: - LocalizedError Conformance
///
/// Provides readable descriptions for UI alerts and debugging logs.
extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL(let urlError):
            return "Invalid URL: \(urlError.localizedDescription)"

        case .noConnection:
            return "No internet connection available"

        case .timeout:
            return "Request timed out"

        case .invalidContentType:
            return "Invalid content type in response"

        case .emptyResponse:
            return "Server returned an empty response"

        case .requestBuildingFailed(let message):
            return "Failed to build request: \(message)"

        case .encodingFailed(let error):
            return "Failed to encode payload: \(error.localizedDescription)"

        case .transportError(let urlError):
            return "Transport error: \(urlError.localizedDescription)"

        case .serverError(let code, let message):
            if let message = message {
                return "Server error (\(code)): \(message)"
            }
            return "Server error with code: \(code)"

        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"

        case .unknown(let error):
            if let error = error {
                return "Unknown error: \(error.localizedDescription)"
            }
            return "An unknown error occurred"
        }
    }
}
