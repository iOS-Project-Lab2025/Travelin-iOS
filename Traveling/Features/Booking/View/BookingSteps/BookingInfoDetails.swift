//
//  BookingInfoDetails.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI

struct BookingInfoDetails: View {

    @Environment(\.appRouter) private var router

    var body: some View {
        VStack {
            Text("Booking Info Details")
            Button {
                router.goTo(.home)
            } label: {
                Text("Go to Home")
            }

        }
    }
}

#Preview {
    BookingInfoDetails()
}
