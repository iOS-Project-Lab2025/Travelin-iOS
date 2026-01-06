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

    var body: some View {
        NavigationStack(path: $bookingRouter.path) {
            BookingTouristPlace()
                .navigationDestination(for: BookingRoutes.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(bookingRouter)
        .onChange(of: bookingRouter.path.count) { _, newCount in
            hideTabBar = newCount > 0
        }
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
    BookingView(hideTabBar: .constant(false))
}
