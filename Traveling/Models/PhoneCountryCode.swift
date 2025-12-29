//
//  PhoneCountry.swift
//  Traveling
//
//  Created by NASH on 15-12-25.
//

import Foundation

struct PhoneCountryCode: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let maxDigits: Int
    let country: String

}
