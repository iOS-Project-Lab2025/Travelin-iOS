//
//  HomeViewModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import Foundation

@Observable
final class HomeViewModel {
    private let title: String = ""
    private let subtitle: String = ""
    var packages: [Package] = []
    var countries: [Country] = []
    var searchDetail = SearchDetail()
    init() {
        self.loadData()
    }
    private func loadData() {
        self.packages = [
            Package(
            id: UUID(),
            imageURL: "package1",
            imagesCollection: [],
            name: "Koh Rong Samloem",
            rating: 3,
            numberReviews: 50,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
        ), Package(
            id: UUID(),
            imageURL: "package1",
            imagesCollection: [],
            name: "Koh Rong Samloem",
            rating: 4,
            numberReviews: 90,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
        )
        ]
        self.countries = [
            Country(
                id: UUID(),
                name: "Cambodia",
                imageURL: "country1"
            ),
            Country(
                id: UUID(),
                name: "Cambodia",
                imageURL: "country1"
            ),
            Country(
                id: UUID(),
                name: "Cambodia",
                imageURL: "country1"
            )
        ]
    }
}
struct SearchDetail {
    var searchText: String = ""
    var searchType: SearchType = .all
}
struct Country: Identifiable {
    let id: UUID
    let name: String
    let imageURL: String
}
enum SearchType {
    case all
    case hotel
    case oversea
}
