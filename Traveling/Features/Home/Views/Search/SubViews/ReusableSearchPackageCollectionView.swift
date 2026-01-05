//
//  ReusablePackageSearchView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 04-01-26.
//

import SwiftUI
import TravelinDesignSystem

struct ReusableSearchPackageCollectionView: View {
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router
    let packages: [Package]
    let totalPackage: Int
    let screenSize: CGSize
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(
                alignment: .center,
                spacing: 0) {
                    ForEach(Array(self.packages.prefix(self.totalPackage))) { package in
                        VStack {
                            HStack {
                                let urlString = package.imagesCollection.first ?? ""
                                let url = URL(string: urlString)
                                self.checkPhaseImageView(url: url)
                                VStack(alignment: .leading, spacing: TravelinDesignSystem.DesignTokens.Spacing.small) {
                                    self.packageNameView(name: package.name)
                                    self.rankingView(rating: package.rating, totalReviews: package.numberReviews)
                                    self.descriptionView(description: package.description)
                                    self.priceView(price: package.price)
                                    if let firstService = package.servicesIncluded.first {
                                        self.servicesView(text: firstService.title)
                                    }
                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Rectangle()
                                .fill(TravelinDesignSystem.DesignTokens.Colors.secondaryButtonText.opacity(0.8))
                                .frame(height: 1)
                                .frame(maxWidth:  self.screenSize.width)
                                .padding(.vertical, TravelinDesignSystem.DesignTokens.Spacing.small)
                        }
                        .onTapGesture {
                            self.router.goTo(.poiDetail(id: package.id))
                        }
                    }
                }
        }
    }
    @ViewBuilder
    private func checkPhaseImageView(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: self.screenSize.width * 0.38, height: self.screenSize.width * 0.38)
                
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
        Text(name)
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .lineLimit(2)
    }
    @ViewBuilder
    private func rankingView(rating: Int, totalReviews: Int) -> some View {
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
        Text(description)
            .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium)
            .foregroundStyle(.primary)
            .lineLimit(1)
    }
    @ViewBuilder
    private func priceView(price: Int) -> some View {
        Text("from $\(price)/person ")
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title2.bold())
    }
    @ViewBuilder
    private func servicesView(text: String) -> some View {
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
