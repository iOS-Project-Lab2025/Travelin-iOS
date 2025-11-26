import Foundation

struct POIRadiusParametersDataModel: QueryParametersProtocol {
    let latitude: Double
    let longitude: Double
    let radius: Double?
    let categories: [POICategory]?
    let limit: Int?
    let offset: Int?
}

struct POIRadiusParametersDomainModel {
    var lat: Double
    var lon: Double
    var radius: Double
    var categories: [POICategory]?
    var limit: Int?
    var offset: Int?
}
