//
//  Package.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import Foundation

struct Package: Identifiable {
    let id: UUID
    let imageURL: String
    let imagesCollection: [String]
    let name: String
    let rating: Int
    let numberReviews: Int
    let description: String
    let isFavorite: Bool
    let price: Int
    let services: Services
}
struct Services: Identifiable {
    let id: UUID
    let title: String
    let subTitle: String
    let icon: String
}
