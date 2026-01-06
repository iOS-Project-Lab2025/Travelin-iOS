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

    /// Route to a specific package/POI detail with complete data.
    /// Used by Home cards and Search rows (router.goTo(.poiDetail(poi:))).
    /// Passes the complete POIDomainModel to DetailPackageView.
    case poiDetail(poi: POIDomainModel)
}

