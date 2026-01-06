//
//  HomePackageCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct HomePackageCollectionView: View {
    /// Router used to navigate from a selected card to the detail route.
    /// Provided by HomeView via .environment(homeRouter).
    /// Routes are defined in HomeRoutes (e.g., .poiDetail).
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router

    /// Shared Home state passed by binding from HomeView.
    /// Allows child cards to mutate Package values (e.g., isFavorite).
    /// Data source for this list is viewModel.allPoiPackages.
    @Binding var viewModel: HomeViewModel

    /// Geometry-driven sizing used by ReusablePackageView.
    /// Keeps consistent card proportions across devices.
    /// Passed from GeometryReader (geo.size).
    let screenSize: CGSize
    
    var body: some View {
        /// Section container: title + horizontal scrolling list.
        /// LazyHStack improves performance for long lists.
        /// Entire section is padded to match the app layout.
        VStack(spacing: 0) {
            self.titleView
            ScrollView(.horizontal) {
                LazyHStack(spacing: TravelinDesignSystem.DesignTokens.Spacing.buttonHorizontal) {
                    /// Iterates bindings so each card can edit the underlying model.
                    /// $package is a Binding<Package> from viewModel.allPoiPackages.
                    /// This enables favorite toggles to persist in the ViewModel.
                    ForEach(self.$viewModel.allPoiPackages) { $package in
                        ReusablePackageView(
                            package: $package,
                            screenSize: self.screenSize,
                            onTap: {
                                /// Card tap triggers navigation to detail by package id.
                                /// HomeView resolves the id and passes Binding<Package> to the detail view.
                                /// Keeps detail screen in sync with Home state.
                                self.router.goTo(.poiDetail(id: package.id))
                            }
                        )
                    }
                }
            }
        }
        .padding()
    }

    private var titleView: some View {
        /// Section header shown above the horizontal list.
        /// Uses design system typography for consistent styling.
        /// Left-aligned across the available width.
        Text("Popular package in asia")
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
    }
}

#Preview {
    /// Preview uses a constant HomeViewModel instance.
    /// Navigation won't work in preview without the router environment.
    /// Useful to validate layout and spacing quickly.
    HomePackageCollectionView(viewModel: .constant(HomeViewModel()), screenSize: UIScreen.main.bounds.size
    )
}

