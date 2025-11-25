import Foundation

/// Protocolo para generar query items automáticamente desde structs
protocol QueryParameters: Encodable {
    func toQueryItems() -> [URLQueryItem]
}

extension QueryParameters {
    func toQueryItems() -> [URLQueryItem] {
        let mirror = Mirror(reflecting: self)
        var items: [URLQueryItem] = []
        for child in mirror.children {
            guard let key = child.label else { continue }
            let value = child.value
            // 1. Si es Optional<Wrapped> = nil → ignorar
            if isNil(value) {
                continue
            }
            // 2. Si es array convertible a string
            if let array = value as? [CustomStringConvertible] {
                items.append(URLQueryItem(
                    name: key,
                    value: array.map { $0.description }.joined(separator: ",")
                ))
                continue
            }
            // 3. Si es enum o básico convertible a string
            if let convertible = value as? CustomStringConvertible {
                items.append(URLQueryItem(name: key, value: convertible.description))
                continue
            }
            // 4. Fallback
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return items
    }
    /// Detectar si un valor es Optional.none
    private func isNil(_ value: Any) -> Bool {
        return "\(value)" == "nil"
    }
}
