//
//  BookingView.swift
//  Traveling
//
//  Created by Ivan Pereira on 21-11-25.
//

import SwiftUI

struct BookingView: View {

    @State private var bookingRouter =
        AppRouter.FlowRouter<BookingRoutes>(flow: [
            .touristPlace,
            .availableDate,
            .infoDetails
        ])

    var body: some View {
        NavigationStack(path: $bookingRouter.path) {
            BookingTouristPlace()
                .navigationDestination(for: BookingRoutes.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(bookingRouter)
    }
        @ViewBuilder
        private func destinationView(for route: BookingRoutes) -> some View {
            switch route {
            case .touristPlace:
                BookingTouristPlace()

            case .availableDate:
                BookingAvailableDate()

            case .infoDetails:
                BookingInfoDetails()
            }
    }
}

#Preview {
    BookingView()
}
