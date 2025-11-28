import Foundation

protocol QueryParametersProtocol: Encodable {
    func toQueryItems() -> [URLQueryItem]
}

extension QueryParametersProtocol {
    func toQueryItems() -> [URLQueryItem] {
        let mirror = Mirror(reflecting: self)
        var items: [URLQueryItem] = []
        for child in mirror.children {
            guard let key = child.label else { continue }
            let value = child.value
            if isNil(value) {
                continue
            }
            if let array = value as? [CustomStringConvertible] {
                items.append(URLQueryItem(
                    name: key,
                    value: array.map { $0.description }.joined(separator: ",")
                ))
                continue
            }
            if let convertible = value as? CustomStringConvertible {
                items.append(URLQueryItem(name: key, value: convertible.description))
                continue
            }
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return items
    }
    private func isNil(_ value: Any) -> Bool {
        return "\(value)" == "nil"
    }
}
