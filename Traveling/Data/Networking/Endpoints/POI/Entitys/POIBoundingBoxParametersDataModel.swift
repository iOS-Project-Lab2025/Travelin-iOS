import Foundation

struct POIBoundingBoxParametersDataModel: QueryParametersProtocol {
    let north: Double
    let south: Double
    let east: Double
    let west: Double
    let categories: [POICategory]?
    let limit: Int?
    let offset: Int?
    
    func getPoint() -> String{
        return "\(west)"
    }
}


struct POIBoundingBoxParametersDomainModel {
    var north: Double
    var south: Double
    var east: Double
    var west: Double
    var categories: [POICategory]?
    var limit: Int?
    var offset: Int?
}
