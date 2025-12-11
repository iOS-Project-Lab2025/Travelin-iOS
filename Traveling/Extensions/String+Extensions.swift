//
//  String+Extension.swift
//  Traveling
//
//  Created by Ivan Pereira on 05-12-25.
//

import Foundation

extension String {
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
}
