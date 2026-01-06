//
//  BookingRoutes.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import Foundation

enum BookingRoutes: Hashable {
    case touristPlace
    case tourDetail(Tour)
    case availableDate(Tour)
    case detailBooking(Tour, Date, Date)
    case bookingSuccess
    case infoDetails
}
