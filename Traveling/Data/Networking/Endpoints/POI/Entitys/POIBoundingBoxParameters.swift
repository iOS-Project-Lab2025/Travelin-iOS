import Foundation

struct POIBoundingBoxParameters: QueryParameters {
    let north: Double
    let south: Double
    let east: Double
    let west: Double
    let categories: [POICategory]?
    let limit: Int?
    let offset: Int?
}
