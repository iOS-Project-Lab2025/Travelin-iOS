//
//  RequestBuilderImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

// MARK: - RequestBuilder Implementation
///
/// `RequestBuilderImp` is responsible for creating fully configured `URLRequest`
/// instances based on an endpoint definition and an optional request body.
/// It coordinates URL creation, headers, HTTP method assignment, and payload encoding.
///
/// ## Responsibilities
/// - Build a `URLRequest` from an `EndPointProtocol` implementation.
/// - Attach common and endpoint-specific headers.
/// - Apply the correct HTTP method.
/// - Encode and attach the body when present.
/// - Validate that body encoding is possible before attempting it.
///
/// ## Usage Example
/// ```swift
/// let requestBuilder = RequestBuilderImp(
///     endPointBuilder: try EndPointBuilderImp(baseURL: "https://api.example.com"),
///     payloadBuilder: PayloadBuilderImp()
/// )
///
/// let request = try requestBuilder.buildRequest(
///     from: AuthEndpoint.login,
///     body: LoginRequest(email: "test@mail.com", password: "1234")
/// )
/// ```
///
/// ## Error Handling
/// - Throws `NetworkingError.requestBuildingFailed` when a body is provided
///   but no `PayloadBuilder` is available.
/// - Propagates URL building errors from `EndPointBuilderProtocol`.
/// - Propagates encoding errors from `PayloadBuilderProtocol`.
///
/// ## Notes
/// - Default common headers include:
///   - `Accept: application/json`
///   - `App-Version: 1.0`
/// - Endpoint headers override common headers when keys match.
/// - The request timeout is set to 30 seconds.
///
/// ## SeeAlso
/// - `EndPointBuilderProtocol`
/// - `PayloadBuilderProtocol`
/// - `NetworkingError`
struct RequestBuilderImp: RequestBuilderProtocol {

    private let endPointBuilder: EndPointBuilderProtocol
    private let payloadBuilder: PayloadBuilderProtocol?

    /// Initializes the request builder with its required dependencies.
    ///
    /// - Parameters:
    ///   - endPointBuilder: Responsible for building the request URL.
    ///   - payloadBuilder: Optional. Required only when requests may contain a body.
    init(endPointBuilder: EndPointBuilderProtocol,
         payloadBuilder: PayloadBuilderProtocol? = nil) {
        self.endPointBuilder = endPointBuilder
        self.payloadBuilder = payloadBuilder
    }

    /// Builds a fully configured `URLRequest` for the specified endpoint.
    ///
    /// - Parameters:
    ///   - endPoint: The endpoint providing HTTP method, path, headers, and query items.
    ///   - body: Optional encodable body to attach to the request.
    ///
    /// - Returns: A valid `URLRequest` instance.
    ///
    /// - Throws:
    ///   - `NetworkingError.invalidURL` if URL construction fails.
    ///   - `NetworkingError.requestBuildingFailed` if a body is present without a payload builder.
    ///   - Encoding errors propagated from `PayloadBuilderProtocol`.
    func buildRequest(
        from endPoint: any EndPointProtocol,
        body: Encodable? = nil
    ) throws -> URLRequest {

        let url = try self.endPointBuilder.buildURL(from: endPoint)
        var request = URLRequest(url: url)

        // Assign HTTP method
        request.httpMethod = endPoint.method.rawValue

        // Common headers
        let commonHeaders = [
            "Accept": "application/json",
            "App-Version": "1.0"
        ]

        // Merge endpoint-specific headers
        var finalHeaders = commonHeaders
        if let endpointHeaders = endPoint.headers {
            for (key, value) in endpointHeaders {
                finalHeaders[key] = value
            }
        }

        request.allHTTPHeaderFields = finalHeaders

        // Attach body if provided
        if let body = body {
            guard payloadBuilder != nil else {
                throw NetworkingError.requestBuildingFailed(
                    "PayloadBuilder is required when body is present"
                )
            }
            request.httpBody = try self.payloadBuilder?.buildPayload(from: body)
        }

        // Default timeout
        request.timeoutInterval = 30
        return request
    }
}
