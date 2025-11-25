import Foundation

enum POIEndpoint: EndPoint {

    case searchRadius(POIRadiusParameters)
    case searchBoundingBox(POIBoundingBoxParameters)
    case getById(String)

    private static let basePath = "/v1/reference-data/locations/pois"

    var path: String {
        switch self {
        case .searchRadius:
            return Self.basePath
        case .searchBoundingBox:
            return Self.basePath + "/by-square"
        case .getById(let id):
            return Self.basePath + "/\(id)"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchRadius(let params):
            return params.toQueryItems()
        case .searchBoundingBox(let params):
            return params.toQueryItems()
        case .getById:
            return nil
        }
    }

    var headers: [String : String]? { nil }
}
