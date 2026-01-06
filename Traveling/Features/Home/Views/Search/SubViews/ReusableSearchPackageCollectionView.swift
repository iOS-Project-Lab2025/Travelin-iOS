//
//  ReusablePackageSearchView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 04-01-26.
//

import SwiftUI
import TravelinDesignSystem

struct ReusableSearchPackageCollectionView: View {
    /// Router for navigation to detail (HomeRoutes).
    /// Provided by HomeView via .environment(homeRouter).
    /// Used when tapping a row.
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router

    /// Immutable list of packages to display (no bindings here).
    /// Parent decides the source: nearby list or filtered list.
    /// This view only renders and navigates.
    let packages: [Package]

    /// Display limit controlled by the parent (e.g., show 3 vs show all).
    /// Implemented using packages.prefix(totalPackage).
    /// Helps SearchView implement "Show/Hide" behavior.
    let totalPackage: Int

    /// Used for responsive sizing (image frame and divider width).
    /// Passed from GeometryReader (geo.size) in HomeView/SearchView.
    /// Keeps layout consistent across devices.
    let screenSize: CGSize
    
    var body: some View {
        /// Vertical scroll list of compact rows (image + details).
        /// LazyVStack improves performance for larger result sets.
        /// Each row navigates to the package detail route on tap.
        ScrollView(.vertical) {
            LazyVStack(
                alignment: .center,
                spacing: 0) {
                    ForEach(Array(self.packages.prefix(self.totalPackage))) { package in
                        VStack(spacing: 0) {
                            HStack {
                                /// Uses the first image URL string as the cover image.
                                /// If invalid/empty, AsyncImage will show placeholder behavior.
                                /// URL parsing is intentionally lightweight.
                                let urlString = package.imagesCollection.first ?? ""
                                let url = URL(string: urlString)
                                self.checkPhaseImageView(url: url)
                                VStack(alignment: .leading, spacing: 4) {
                                    self.packageNameView(name: package.name)
                                    self.rankingView(rating: package.rating, totalReviews: package.numberReviews)
                                    self.descriptionView(description: package.description)
                                    self.priceView(price: package.price)
                                    /// Shows the first included service as a small badge, if available.
                                    /// Keeps the row compact while still surfacing one key attribute.
                                    /// The list can be extended later if needed.
                                    if let firstService = package.servicesIncluded.first {
                                        self.servicesView(text: firstService.title)
                                    }
                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            /// Row divider for visual separation between items.
                            /// Uses design system colors and consistent thickness.
                            /// Width matches the available screen width.
                            Rectangle()
                                .fill(TravelinDesignSystem.DesignTokens.Colors.secondaryButtonText.opacity(0.8))
                                .frame(height: 1)
                                .frame(maxWidth:  self.screenSize.width)
                                .padding(.vertical, TravelinDesignSystem.DesignTokens.Spacing.small)
                        }
                        /// Tapping a row routes to the detail screen using package id.
                        /// HomeView resolves the route and builds the destination.
                        /// Keeps navigation consistent across Home and Search.
                        .onTapGesture {
                            self.router.goTo(.poiDetail(id: package.id))
                        }
                    }
                }
        }
    }

    @ViewBuilder
    private func checkPhaseImageView(url: URL?) -> some View {
        // AsyncImage phase handler: loading, success, failure, unknown.
        // Fixed square frame prevents layout jumps while loading.
        // Styling matches the search row card aesthetic.
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: self.screenSize.width * 0.33, height: self.screenSize.width * 0.33)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure(let error):
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding(TravelinDesignSystem.DesignTokens.Spacing.mediumLarge)
                    .foregroundStyle(TravelinDesignSystem.DesignTokens.Colors.secondaryButtonBackground)
                
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: self.screenSize.width * 0.38, height: self.screenSize.width * 0.38)
        .cornerRadius(15)
        .clipped()
        .overlay(TravelinDesignSystem.DesignTokens.Colors.primaryText.opacity(0.2))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func packageNameView(name: String) -> some View {
        // Package title displayed in the row.
        // Allows up to 2 lines to prevent truncating long names too aggressively.
        // Uses design system typography for consistency.
        Text(name)
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .lineLimit(2)
    }

    @ViewBuilder
    private func rankingView(rating: Int, totalReviews: Int) -> some View {
        // 5-star rating visualization using an integer threshold.
        // Stars become yellow up to the rating; remaining are gray.
        // Appends review count and label.
        HStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium)
                    .foregroundStyle(rating >= index + 1 ? .yellow : .gray)
                
            }
            Text("\(totalReviews)")
                .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium)
                .foregroundStyle(.primary)
                .padding(.leading)
            
            Text(" reviews")
                .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium)
                .foregroundStyle(.primary)
        }
    }

    @ViewBuilder
    private func descriptionView(description: String) -> some View {
        // One-line preview of the description for compact rows.
        // Uses primary color but smaller typography.
        // Line limit keeps row height stable.
        Text(description)
            .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium)
            .foregroundStyle(.primary)
            .lineLimit(1)
    }

    @ViewBuilder
    private func priceView(price: Int) -> some View {
        // Price label formatted as "from $X/person".
        // Bold style emphasizes pricing in search results.
        // Uses design system typography for consistent weight.
        Text("from $\(price)/person ")
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title2.bold())
    }

    @ViewBuilder
    private func servicesView(text: String) -> some View {
        // Small badge-style label for the first included service.
        // Uses a stroked rectangle to read like a tag/chip.
        // Padding comes from design system spacing.
        Text(text)
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title2)
            .padding(.all, TravelinDesignSystem.DesignTokens.Spacing.iconSpacingSmall)
            .overlay {
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.gray.opacity(0.8), lineWidth: 1)
            }
    }
}
