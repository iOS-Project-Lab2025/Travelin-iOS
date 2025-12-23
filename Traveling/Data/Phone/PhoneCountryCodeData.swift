//
//  Untitled.swift
//  Traveling
//
//  Created by NASH on 15-12-25.
//

import Foundation

struct PhoneCountryCodeData {

    // MARK: - Raw Data
    private static let countriesData: [(code: String, maxDigits: Int, country: String)] = [
        ("+56", 9, "Chile"),
        ("+1", 10, "USA")
    ]

    // MARK: - Public Interface
    static func getAllCountryCodes() -> [PhoneCountryCode] {
        return countriesData.map { data in
            PhoneCountryCode(
                code: data.code,
                maxDigits: data.maxDigits,
                country: data.country
            )
        }
    }

    static func getCountryCode(by code: String) -> PhoneCountryCode? {
        return getAllCountryCodes().first { $0.code == code }
    }

    static func getDefaultCountryCode() -> PhoneCountryCode {
        // Puedes cambiar esto según tu lógica (detectar región, etc.)
        return PhoneCountryCode(
            code: countriesData[0].code,
            maxDigits: countriesData[0].maxDigits,
            country: countriesData[0].country
        )
    }
}
