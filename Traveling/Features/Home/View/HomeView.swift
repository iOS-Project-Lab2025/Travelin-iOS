//
//  MainView.swift
//  Traveling
//
//  Created by Ivan Pereira on 18-11-25.
//

import SwiftUI

struct HomeView: View {
    @State private var homeRouter = AppRouter.FlowRouter<HomeRoutes>(flow: [.home, .poiSearch, .poiDetail])
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
                .navigationDestination(for: HomeRoutes.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .poiSearch:
                        SearchView(packages: $viewModel.packages, inputText: $viewModel.searchDetail.searchText, router: $homeRouter, size: geo.size)
                    case .poiDetail:
                        Text("Detail")
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
    case poiDetail
}
