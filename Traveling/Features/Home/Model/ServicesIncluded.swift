//
//  ServicesIncluded.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 05-01-26.
//

import Foundation

struct ServicesIncluded: Identifiable, Codable, Hashable {
    /// Unique identifier for SwiftUI diffing and stable list rendering.
    /// Useful when displaying multiple included services in a ForEach.
    /// Generated per service item.
    let id: UUID

    /// Primary user-facing label (e.g., "2 day 1 night").
    /// Currently used in Search results as the badge text (first item only).
    /// Should be short and readable.
    let title: String

    /// Secondary descriptor for the service (e.g., "Duration").
    /// Not currently shown in UI, but supports richer detail layouts later.
    /// Can be used as a label/category name.
    let subTitle: String

    /// Icon identifier (typically an SF Symbol name like "clock.fill").
    /// Stored for future UI rendering (icon + text badges).
    /// Must match an available symbol/asset to display correctly.
    let icon: String
}

