//
//  DetailPackageView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 04-01-26.
//

import SwiftUI

struct DetailPackageView: View {
    /// The selected POI from the source list, containing real data from the endpoint.
    /// HomeView passes the complete POIDomainModel when navigating to this screen.
    /// Contains all POI information needed for display and booking navigation.
    let poi: POIDomainModel
    
    @Environment(\.appRouter) private var appRouter

    var body: some View {
        /// Minimal detail layout: name, category, and coordinates.
        /// Uses plain Text views without design system styling for now.
        /// Consider wrapping in ScrollView later if content grows.
        VStack(spacing: 20) {
            Text(poi.name)
                .font(.title)
                .bold()
            
            Text("Category: \(poi.category)")
                .font(.subheadline)
            
            Text("Location: \(poi.lat), \(poi.lon)")
                .font(.caption)
                .foregroundColor(.gray)
            
            // Button to navigate to booking with this POI
            Button {
                // Create temporary Package with POI data to maintain consistency
                let tempPackage = Package(
                    id: poi.id,
                    imagesCollection: poi.pictures ?? [],
                    name: poi.name,
                    rating: 5,
                    numberReviews: 20,
                    description: "Visit \(poi.name), a beautiful \(poi.category) destination.",
                    isFavorite: false,
                    price: 100,
                    servicesIncluded: [ServicesIncluded(
                        id: UUID(),
                        title: "1 day",
                        subTitle: "Duration",
                        icon: "clock.fill"
                    )],
                    poiSource: poi
                )
                appRouter.goTo(.bookingWithPackage(tempPackage))
            } label: {
                Text("Book Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    /// Preview uses sample POIDomainModel data from the endpoint structure.
    /// Useful to verify basic layout and data display.
    DetailPackageView(poi: POIDomainModel(
        id: "01",
        name: "Koh Rong Samloem",
        pictures: ["https://example.com/image.jpg"],
        lat: 10.5,
        lon: 103.5,
        category: "BEACH_PARK"
    ))
}

