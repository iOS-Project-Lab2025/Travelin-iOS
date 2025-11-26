import Foundation

/*
 struct POIResponse: Decodable {
     let data: [POI]
     let meta: Meta
 }

 */
struct POISingleResponse: Decodable {
    let data: POIDataModel
}

struct POIListResponse: Decodable {
    let data: [POIDataModel]
    let meta: Meta
}


// MARK: - Self Link
struct POISelfLink: Decodable {
    let href: String
    let methods: [String]
}

// MARK: - GeoCode
struct GeoCode: Decodable {
    let latitude: Double
    let longitude: Double
}

// MARK: - Meta
struct Meta: Decodable {
    let count: Int
    let links: PaginationLinks
}

// MARK: - Pagination Links
struct PaginationLinks: Decodable {
    let selfLink: String?
    let first: String?
    let last: String?
    let next: String?
    let up: String?
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case first, last, next, up
    }
}



