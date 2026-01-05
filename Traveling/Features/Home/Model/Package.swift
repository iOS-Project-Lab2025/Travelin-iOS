//
//  Package.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import Foundation

struct Package: Identifiable {
    let id: String
    let imagesCollection: [String]
    let name: String
    let rating: Int
    let numberReviews: Int
    let description: String
    var isFavorite: Bool
    let price: Int
    let servicesIncluded: [ServicesIncluded]
}

