//
//  QueryParametersProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

// MARK: - QueryParameters Protocol
///
/// A protocol for types that represent URL query parameters.
/// Conforming types must be `Encodable` and provide a method that converts
/// their stored properties into an array of `URLQueryItem`.
///
/// This allows models to automatically map their properties into URL query
/// parameters without manually building them.
///
/// ## Responsibilities
/// - Transform model fields into `URLQueryItem` objects.
/// - Allow reusable and clean query parameter handling for endpoints.
///
/// ## Usage Example
/// ```swift
/// struct SearchParameters: QueryParametersProtocol {
///     let text: String?
///     let limit: Int?
/// }
///
/// let params = SearchParameters(text: "coffee", limit: 20)
/// let queryItems = params.toQueryItems()
/// ```
///
/// ## Notes
/// - Uses reflection (`Mirror`) to inspect property names and values.
/// - Handles:
///   - optional values
///   - arrays of `CustomStringConvertible`
///   - values conforming to `CustomStringConvertible`
/// - Skip properties whose values are `nil`.
///
/// ## SeeAlso
/// - `EndPointProtocol`
/// - `URLQueryItem`
protocol QueryParametersProtocol: Encodable {
    /// Converts the object's stored properties into query items.
    func toQueryItems() -> [URLQueryItem]
}

extension QueryParametersProtocol {

    /// Default implementation that uses reflection to generate query items.
    ///
    /// - Returns: An array of `URLQueryItem` built from non-nil properties.
    func toQueryItems() -> [URLQueryItem] {
        let mirror = Mirror(reflecting: self)
        var items: [URLQueryItem] = []

        for child in mirror.children {
            guard let key = child.label else { continue }
            let value = child.value

            // Skip nil values (String(describing: nil) → "nil")
            if isNil(value) {
                continue
            }

            // Handle arrays of values that conform to CustomStringConvertible
            if let array = value as? [CustomStringConvertible] {
                items.append(
                    URLQueryItem(
                        name: key,
                        value: array.map { $0.description }.joined(separator: ",")
                    )
                )
                continue
            }

            // Handle single values conforming to CustomStringConvertible
            if let convertible = value as? CustomStringConvertible {
                items.append(URLQueryItem(name: key, value: convertible.description))
                continue
            }

            // Fallback for values not conforming to CustomStringConvertible
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }

        return items
    }

    /// Helper to determine whether a value is an optional `.none`.
    ///
    /// - Parameter value: The reflected value.
    /// - Returns: `true` if the value is effectively nil.
    private func isNil(_ value: Any) -> Bool {
        return "\(value)" == "nil"
    }
}
