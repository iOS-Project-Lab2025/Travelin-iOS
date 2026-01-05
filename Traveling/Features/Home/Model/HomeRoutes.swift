//
//  HomeRoutes.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 05-01-26.
//

import Foundation

enum HomeRoutes: Hashable {
    /// Route to the Search screen for POIs/packages.
    /// Triggered from TopHomeView when tapping the search field area.
    /// Resolved in HomeView.navigationDestination to show SearchView.
    case poiSearch

    /// Route to a specific package/POI detail by identifier.
    /// Used by Home cards and Search rows (router.goTo(.poiDetail(id:))).
    /// HomeView resolves the id and passes Binding<Package> to DetailPackageView.
    case poiDetail(id: String)
}

