import Foundation

enum POICategory: String, CaseIterable, CustomStringConvertible, Encodable {
    case sights = "SIGHTS"
    case beachPark = "BEACH_PARK"
    case historical = "HISTORICAL"
    case nightlife = "NIGHTLIFE"
    case restaurant = "RESTAURANT"
    case shopping = "SHOPPING"

    var description: String { rawValue }
}
