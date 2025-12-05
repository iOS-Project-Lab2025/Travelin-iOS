//
//  EndPoint.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

// MARK: - EndPoint Protocol
///
/// `EndPointProtocol` defines the essential components required to describe
/// an API endpoint in the networking layer.
///
/// Each endpoint specifies:
/// - The HTTP method (`GET`, `POST`, etc.)
/// - The path appended to the base URL
/// - Optional query parameters
/// - Optional custom request headers
///
/// This abstraction enables a clear and consistent way to define API routes
/// while keeping networking components decoupled.
///
/// ## Responsibilities
/// - Provide endpoint configuration (`method`, `path`, `queryItems`, `headers`)
/// - Allow `RequestBuilderImp` and `EndPointBuilderImp` to build requests
///
/// ## Usage Example
/// ```swift
/// enum UserEndpoint: EndPointProtocol {
///     case getProfile(id: String)
///
///     var method: HTTPMethod { .get }
///
///     var path: String {
///         switch self {
///         case .getProfile(let id): return "/v1/users/\(id)"
///         }
///     }
///
///     var queryItems: [URLQueryItem]? { nil }
///     var headers: [String: String]? { ["Authorization": "Bearer token"] }
/// }
/// ```
///
/// ## Notes
/// - `queryItems` and `headers` include default empty implementations,
///   allowing endpoints to omit them unless needed.
/// - Works closely with:
///   - `EndPointBuilderImp` (URL construction)
///   - `RequestBuilderImp` (request construction)
///
/// ## SeeAlso
/// - `HTTPMethod`
/// - `EndPointBuilderProtocol`
/// - `RequestBuilderProtocol`
protocol EndPointProtocol {
    /// The HTTP method used for the request (GET, POST, PUT, etc.)
    var method: HTTPMethod { get }

    /// The endpoint-specific path appended to the base URL.
    var path: String { get }

    /// Optional query parameters to include in the final URL.
    var queryItems: [URLQueryItem]? { get }

    /// Optional custom headers to attach to the request.
    var headers: [String: String]? { get }
}

extension EndPointProtocol {
    /// Default implementation: no query items.
    var queryItems: [URLQueryItem]? { nil }

    /// Default implementation: no custom headers.
    var headers: [String: String]? { nil }
}
