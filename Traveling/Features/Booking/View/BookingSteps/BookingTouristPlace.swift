//
//  BookingTouristPlace.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI

struct BookingTouristPlace: View {

    @Environment(AppRouter.PathRouter<BookingRoutes>.self) var bookingRouter

    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Select a Tour")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Tour List
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(Tour.mockTours) { tour in
                        TourCardView(tour: tour) {
                            bookingRouter.goTo(.tourDetail(tour))
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    BookingTouristPlace()
        .environment(AppRouter.PathRouter<BookingRoutes>())
}
