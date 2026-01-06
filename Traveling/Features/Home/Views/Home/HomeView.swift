//
//  HomeView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import SwiftUI

struct HomeView: View {
    /// Local router instance powering NavigationStack path-based navigation.
    /// Injected into the environment so child views can push HomeRoutes.
    @State private var homeRouter = AppRouter.PathRouter<HomeRoutes>()

    /// Single source of truth for Home/Search/Detail shared state.
    /// Passed down as bindings so child views can mutate packages and search state.
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        /// NavigationStack is driven by the router's path (HomeRoutes entries).
        /// GeometryReader provides a consistent screenSize for responsive children.
        NavigationStack(path: self.$homeRouter.path) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    /// Hero header; binds searchDetail so filters/text stay shared.
                    /// ignoresSafeArea makes the hero image extend under the status bar.
                    TopHomeView(
                        searchDetail: self.$viewModel.searchDetail,
                        screenSize: geo.size
                    )
                    .ignoresSafeArea(edges: .top)
                    .onAppear {
                        /// Reset search text when returning to Home.
                        /// Keeps the Home header field visually empty by default.
                        self.viewModel.searchDetail.searchText = ""
                    }

                    /// Main scrollable Home content: packages section + countries section.
                    /// Packages uses a viewModel binding (supports favorite toggles).
                    /// Countries uses value data from viewModel.countries.
                    ScrollView(.vertical) {
                        HomePackageCollectionView(
                            viewModel: self.$viewModel,
                            screenSize: geo.size
                        )
                        HomeCountriesCollectionView(
                            countries: self.viewModel.countries,
                            screenSize: geo.size
                        )
                    }
                    .padding(.top)
                }
                /// Normalize the search filter state when Home appears.
                /// (Existing note kept) ✅ Mejor lugar para async
                /// Ensures filter buttons start from .all when coming back to Home.
                .onAppear {  // ✅ Mejor lugar para async
                    self.viewModel.searchDetail.searchType = .all
                }
                .ignoresSafeArea(edges: .top)

                /// Route mapping for HomeRoutes → destination views.
                /// Search receives viewModel binding to run fetch/filter logic.
                /// Detail receives the complete POIDomainModel with real data.
                .navigationDestination(for: HomeRoutes.self) { route in
                    switch route {
                    case .poiSearch:
                        SearchView(viewModel: self.$viewModel, screenSize: geo.size)
                    case .poiDetail(let poi):
                        DetailPackageView(poi: poi)
                    }
                }
            }
        }
        /// Makes this router available to subviews via @Environment.
        /// Needed by TopHomeView/HomePackageCollectionView/SearchView for navigation.
        .environment(self.homeRouter)
    }
}


