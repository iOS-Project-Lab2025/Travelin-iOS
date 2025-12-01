//
//  NetworkServiceImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 19-11-25.
//

import Foundation

/// MARK: - NetworkService Implementation
///
/// `NetworkServiceImp` orchestrates the entire HTTP request lifecycle, including:
/// - building a `URLRequest` from the endpoint
/// - sending the request via a `NetworkClientProtocol` implementation
/// - validating the HTTP response
/// - decoding JSON responses
/// - mapping errors into a unified `NetworkingError`
///
/// This layer provides a clean abstraction used by repositories and
/// other parts of the application that require data from remote sources.
///
/// ## Responsibilities
/// - Build the request using `RequestBuilderProtocol`
/// - Execute the request using `NetworkClientProtocol`
/// - Validate HTTP status codes
/// - Ensure proper `Content-Type`
/// - Decode the response into the expected type
/// - Map networking, decoding, and server errors into meaningful `NetworkingError` values
///
/// ## Notes
/// - Uses `.convertFromSnakeCase` to match common REST API conventions.
/// - Logs the request details for debugging purposes.
/// - Implements robust error handling with retry-safe error propagation.
///
/// ## Usage Example
/// ```swift
/// let service = NetworkServiceImp(client: client, requestBuilder: builder)
/// let response: User = try await service.execute(UserEndpoint.getById("123"), responseType: User.self)
/// ```
final class NetworkServiceImp: NetworkServiceProtocol {
    
    private let client: NetworkClientProtocol
    private let requestBuilder: RequestBuilderProtocol
    private let decoder: JSONDecoder
    
    /// Initializes the network service with its required dependencies.
    ///
    /// - Parameters:
    ///   - client: Responsible for low-level HTTP execution.
    ///   - requestBuilder: Builds the request object.
    ///   - decoder: Used to decode JSON responses (defaults to snake_case conversion).
    init(
        client: NetworkClientProtocol,
        requestBuilder: RequestBuilderProtocol,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.client = client
        self.requestBuilder = requestBuilder
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    /// Executes an endpoint request and decodes its response into the provided type.
    ///
    /// - Parameters:
    ///   - endPoint: The endpoint definition containing method, path, and headers.
    ///   - responseType: The expected type of the decoded response.
    ///   - body: Optional request body for POST, PUT, PATCH operations.
    ///
    /// - Returns: A decoded instance of type `T`.
    ///
    /// - Throws:
    ///   - `NetworkingError.invalidURL`
    ///   - `NetworkingError.requestBuildingFailed`
    ///   - `NetworkingError.noConnection`, `.timeout`, `.transportError`
    ///   - `NetworkingError.invalidContentType`
    ///   - `NetworkingError.serverError`
    ///   - `NetworkingError.decodingFailed`
    ///   - `NetworkingError.emptyResponse`
    ///   - `NetworkingError.unknown`
    func execute<T: Decodable>(
        _ endPoint: any EndPointProtocol,
        responseType: T.Type,
        body: Encodable? = nil
    ) async throws -> T {
        
        // Build the URLRequest
        let request = try self.requestBuilder.buildRequest(from: endPoint, body: body)
        
        // -------------------------------------------------------------
        // 🔵 Debug Logging (always printed)
        // -------------------------------------------------------------
        print("🌍 NETWORK REQUEST")
        print("➡️ URL:", request.url?.absoluteString ?? "NO URL")
        print("➡️ METHOD:", request.httpMethod ?? "NO METHOD")
        
        if let headers = request.allHTTPHeaderFields {
            print("➡️ HEADERS:", headers)
        }
        
        if let body = request.httpBody,
           let json = String(data: body, encoding: .utf8) {
            print("➡️ BODY:", json)
        } else {
            print("➡️ BODY: <empty>")
        }
        
        print("-----------------------------------------------------")
        
        do {
            // Execute the request
            let (data, response) = try await self.client.execute(request)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkingError.transportError(URLError(.badServerResponse))
            }
            
            // Status Code Validation
            switch http.statusCode {
            case 200..<300:
                // Validate Content-Type header (soft validation)
                if let contentType = http.value(forHTTPHeaderField: "Content-Type") {
                    print("📦 Content-Type received: '\(contentType)'")
                } else {
                    print("⚠️ Content-Type header missing")
                }
                
                if let contentType = http.value(forHTTPHeaderField: "Content-Type"),
                   !contentType.isEmpty,
                   !contentType.lowercased().contains("json") {
                    print("❌ Invalid Content-Type:", contentType)
                    throw NetworkingError.invalidContentType
                }
                
            case 400..<500:
                let errorMessage = parseServerError(from: data) ?? "Client error"
                throw NetworkingError.serverError(code: http.statusCode, message: errorMessage)
                
            case 500..<600:
                let errorMessage = parseServerError(from: data) ?? "Server error"
                throw NetworkingError.serverError(code: http.statusCode, message: errorMessage)
                
            default:
                throw NetworkingError.transportError(URLError(.badServerResponse))
            }
            
            // Ensure non-empty body for successful responses
            guard !data.isEmpty else {
                throw NetworkingError.emptyResponse
            }
            
            // Decode response
            do {
                return try self.decoder.decode(T.self, from: data)
            } catch {
                throw NetworkingError.decodingFailed(error)
            }
            
        // MARK: - NetworkingError passthrough
        } catch let networkingError as NetworkingError {
            throw networkingError
            
        // MARK: - URLError → NetworkingError mapping
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                throw NetworkingError.noConnection
            case .timedOut:
                throw NetworkingError.timeout
            default:
                throw NetworkingError.transportError(urlError)
            }
            
        // MARK: - Fallback unknown error
        } catch {
            throw NetworkingError.unknown(error)
        }
    }
    
    /// Attempts to decode the server error payload using `ErrorResponse`.
    ///
    /// - Parameter data: The raw error response body.
    /// - Returns: The extracted error message if available, otherwise nil.
    private func parseServerError(from data: Data) -> String? {
        guard let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: data) else {
            return nil
        }
        return errorResponse.message
    }
}

