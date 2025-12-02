//
//  EndpointBuilderProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

// MARK: - EndPointBuilder Protocol
///
/// Defines the required functionality for any component that builds URLs
/// from endpoint definitions.
///
/// This protocol abstracts URL construction logic, enabling flexible
/// implementations (production, mock, testing, etc.).
///
/// ## Responsibilities
/// - Convert an `EndPointProtocol` instance into a fully resolved `URL`.
///
/// ## Example
/// ```swift
/// let url = try builder.buildURL(from: MyEndpoint.profile)
/// ```
///
/// ## Notes
/// - Implementations must handle validation and throw errors when URL creation fails.
/// - Typically used by `RequestBuilderProtocol` in the networking layer.
///
/// ## SeeAlso
/// - `EndPointProtocol`
/// - `EndPointBuilderImp`
protocol EndPointBuilderProtocol {

    /// Builds a valid URL using the provided endpoint.
    ///
    /// - Parameter endPoint: The endpoint containing path and query information.
    /// - Throws: An error when URL construction fails.
    /// - Returns: A complete `URL`.
    func buildURL(from endPoint: EndPointProtocol) throws -> URL
}
