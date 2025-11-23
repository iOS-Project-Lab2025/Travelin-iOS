//
//  BookingTouristPlace.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI

struct BookingTouristPlace: View {

    @Environment(AppRouter.FlowRouter<BookingRoutes>.self) var bookingRouter

    var body: some View {
        VStack {
            Text("Booking Tourist Place")
            Button {
                bookingRouter.next()
            } label: {
                Text("Next")
            }

        }
    }
}

#Preview {
    BookingTouristPlace()
}
