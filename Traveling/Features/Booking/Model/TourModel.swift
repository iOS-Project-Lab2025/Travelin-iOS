//
//  TourModel.swift
//  Traveling
//
//  Created by Daniel Retamal on 04-01-26.
//

import Foundation

struct Tour: Identifiable, Hashable {
    let id: String
    let name: String
    let location: String
    let price: Double
    let currency: String
    let rating: Double
    let reviewsCount: Int
    let description: String
    let duration: String
    let productCode: String
    let transportation: String
    let images: [String]
    let totalPhotos: Int
    
    init(
        id: String = UUID().uuidString,
        name: String,
        location: String,
        price: Double,
        currency: String = "USD",
        rating: Double,
        reviewsCount: Int,
        description: String,
        duration: String,
        productCode: String,
        transportation: String,
        images: [String],
        totalPhotos: Int
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.price = price
        self.currency = currency
        self.rating = rating
        self.reviewsCount = reviewsCount
        self.description = description
        self.duration = duration
        self.productCode = productCode
        self.transportation = transportation
        self.images = images
        self.totalPhotos = totalPhotos
    }
}

// MARK: - Mock Data
extension Tour {
    static let mockTour = Tour(
        name: "Koh Rong Samloem",
        location: "Krong Siem Reap",
        price: 600,
        rating: 4.5,
        reviewsCount: 100,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Convallis condimentum morbi non egestas enim amet sagittis. Proin sed aliquet rhoncus ut pellentesque ullamcorper sit eget ac. Sit nisi, cras amet varius eget egestas pellentesque. Cursus gravida euismod non...",
        duration: "2 day 1 night",
        productCode: "TAC200812695",
        transportation: "Bus",
        images: ["tour1", "tour2", "tour3"],
        totalPhotos: 120
    )
    
    static let mockTours: [Tour] = [
        mockTour,
        Tour(
            name: "Angkor Wat Temple",
            location: "Siem Reap",
            price: 450,
            rating: 4.8,
            reviewsCount: 250,
            description: "Explore the magnificent Angkor Wat temple complex, one of the most important archaeological sites in Southeast Asia.",
            duration: "1 day",
            productCode: "TAC200812696",
            transportation: "Van",
            images: ["temple1", "temple2", "temple3"],
            totalPhotos: 85
        ),
        Tour(
            name: "Phnom Penh City Tour",
            location: "Phnom Penh",
            price: 350,
            rating: 4.3,
            reviewsCount: 175,
            description: "Discover the rich history and culture of Cambodia's capital city with visits to the Royal Palace and more.",
            duration: "6 hours",
            productCode: "TAC200812697",
            transportation: "Tuk-tuk",
            images: ["city1", "city2", "city3"],
            totalPhotos: 60
        )
    ]
}
