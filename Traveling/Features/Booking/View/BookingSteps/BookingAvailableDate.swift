//
//  BookingAvailableDate.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI

struct BookingAvailableDate: View {

    @Environment(AppRouter.FlowRouter<BookingRoutes>.self) var bookingRouter

    var body: some View {
        VStack {
            Text("Booking Available Date")
            Button {
                bookingRouter.next()
            } label: {
                Text("next")
            }

        }
    }
}

// #Preview {
//    BookingAvailableDate()
// }
