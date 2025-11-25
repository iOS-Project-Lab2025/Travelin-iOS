import Foundation

struct POIRadiusParameters: QueryParameters {
    let latitude: Double
    let longitude: Double
    let radius: Double?
    let categories: [POICategory]?
    let limit: Int?
    let offset: Int?
}
