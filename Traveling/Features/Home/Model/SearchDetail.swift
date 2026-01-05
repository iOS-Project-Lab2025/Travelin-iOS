//
//  SearchDetail.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 05-01-26.
//

import Foundation

struct SearchDetail {
    /// Current query text shared between Home header and Search screen.
    /// Bound to DSTextField in TopHomeView and SearchView.
    /// HomeView resets this to "" when returning to Home.
    var searchText: String = ""

    /// Selected search category/filter (used by TopHomeView buttons).
    /// Default is .all; toggled by Hotel/Oversea buttons.
    /// Not currently applied inside updateSearch() filtering logic.
    var searchType: SearchType = .all
}

enum SearchType {
    /// Default state (no category filtering selected).
    /// Used to render filter buttons as unselected.
    /// HomeView normalizes to .all on appear.
    case all

    /// Category selection intended for hotel-related searches.
    /// Currently impacts UI state (button variant) only.
    /// Can be used later to filter API requests or results.
    case hotel

    /// Category selection intended for overseas-related searches.
    /// Currently impacts UI state (button variant) only.
    /// Can be connected to filtering logic in the future.
    case oversea
}

