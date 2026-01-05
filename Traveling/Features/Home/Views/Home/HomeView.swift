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
                    TopHomeView(searchDetail: $viewModel.searchDetail, router: $homeRouter, screenSize: geo.size)
                        .ignoresSafeArea(edges: .top)
                        .onAppear {
                            viewModel.searchDetail.searchText = ""
                        }
                    ScrollView(.vertical) {
                        HomePackageCollectionView(
                            packages: $viewModel.allPoiPackages,
                            router: $homeRouter,
                            screenSize: geo.size
                        )
                        HomeCountriesCollectionView(
                            countries: viewModel.countries,
                            screenSize: geo.size
                        )
                    }
                    .padding(.top)
                }
                .ignoresSafeArea(edges: .top)
                .navigationDestination(for: HomeRoutes.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .poiSearch:
                        SearchView(viewModel: $viewModel, router: $homeRouter, size: geo.size)
                    case .poiDetail(let id):
                        if let package = viewModel.allPoiPackages.first(where: { $0.id == id }) {
                               DetailPackageView(package: package)
                           } else {
                               Text("Not found")
                           }
                    }
                }
            }
        }
        .environment(homeRouter)
    }
}

enum HomeRoutes: Hashable {
    case home
    case poiSearch
    case poiDetail(id: String)
}
