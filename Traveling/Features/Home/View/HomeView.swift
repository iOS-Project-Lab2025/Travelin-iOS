//
//  MainView.swift
//  Traveling
//
//  Created by Ivan Pereira on 18-11-25.
//

import SwiftUI

struct HomeView: View {
    @State private var homeRouter = AppRouter.PathRouter<HomeRoutes>()
    @State private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack(path: $homeRouter.path) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    TopHomeView(searchDetail: $viewModel.searchDetail, screenSize: geo.size)
                        .ignoresSafeArea(edges: .top)

                    ScrollView(.vertical) {
                        HomePackageCollectionView(
                            packages: $viewModel.packages,
                            screenSize: geo.size
                        )

                        HomeCountriesCollectionView(
                            countries: $viewModel.countries,
                            screenSize: geo.size
                        )
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
        }
        .environment(homeRouter)
    }
}

enum HomeRoutes: Hashable {
    case globalSearch
    case tourList
}
