//
//  BookingView.swift
//  Traveling
//
//  Created by Ivan Pereira on 21-11-25.
//

import SwiftUI

struct BookingView: View {

    @State private var bookingRouter = AppRouter.PathRouter<BookingRoutes>()
    @Binding var hideTabBar: Bool
    let selectedPackage: Package?

    var body: some View {
        NavigationStack(path: $bookingRouter.path) {
            Group {
                if let package = selectedPackage {
                    // If a Package is selected, go directly to the tour detail
                    TourDetailView(tour: packageToTour(package))
                } else {
                    // If no Package, show the tours list
                    BookingTouristPlace()
                }
            }
            .navigationDestination(for: BookingRoutes.self) { route in
                destinationView(for: route)
            }
        }
        .environment(bookingRouter)
        .onChange(of: bookingRouter.path.count) { _, newCount in
            hideTabBar = newCount > 0
        }
    }
    
    /// Converts a Package into a Tour for use in the booking flow.
    /// Uses the Package's rating and reviews values to maintain consistency.
    private func packageToTour(_ package: Package) -> Tour {
        let poi = package.poiSource
        return Tour(
            id: poi.id,
            name: poi.name,
            location: "\(poi.lat), \(poi.lon)",
            price: Double(package.price),
            rating: Double(package.rating),
            reviewsCount: package.numberReviews,
            description: package.description,
            duration: package.servicesIncluded.first(where: { $0.subTitle == "Duration" })?.title ?? "1 day",
            productCode: poi.id,
            transportation: "Bus",
            images: poi.pictures ?? [],
            totalPhotos: poi.pictures?.count ?? 0
        )
    }
    
    @ViewBuilder
    private func destinationView(for route: BookingRoutes) -> some View {
            switch route {
            case .touristPlace:
                BookingTouristPlace()

            case .tourDetail(let tour):
                TourDetailView(tour: tour)

            case .availableDate(let tour):
                AvailableDateView(tour: tour)

            case .detailBooking(let tour, let startDate, let endDate):
                DetailBookingView(tour: tour, startDate: startDate, endDate: endDate)
            
            case .bookingSuccess:
                SuccessMessageView(successType: .bookingSuccess)

            case .infoDetails:
                BookingInfoDetails()
        }
    }
}

#Preview {
    BookingView(hideTabBar: .constant(false), selectedPackage: nil)
}
