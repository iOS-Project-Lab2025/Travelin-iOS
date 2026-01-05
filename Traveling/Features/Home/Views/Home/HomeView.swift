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
        NavigationStack(path: self.$homeRouter.path) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    TopHomeView(
                        searchDetail: self.$viewModel.searchDetail,
                        screenSize: geo.size
                    )
                        .ignoresSafeArea(edges: .top)
                        .onAppear {
                            self.viewModel.searchDetail.searchText = ""
                        }
                    ScrollView(.vertical) {
                        HomePackageCollectionView(
                            packages: self.viewModel.allPoiPackages,
                            screenSize: geo.size
                        )
                        HomeCountriesCollectionView(
                            countries: self.viewModel.countries,
                            screenSize: geo.size
                        )
                    }
                    .padding(.top)
                }
                .ignoresSafeArea(edges: .top)
                .navigationDestination(for: HomeRoutes.self) { route in
                    switch route {
                    case .poiSearch:
                        SearchView(viewModel: self.$viewModel, screenSize: geo.size)
                    case .poiDetail(let id):
                        if let package = self.viewModel.allPoiPackages.first(where: { $0.id == id }) {
                            DetailPackageView(package: package)
                        } else {
                            Text("Not found")
                        }
                    }
                }
            }
        }
        .environment(self.homeRouter)
    }
}


