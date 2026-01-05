//
//  ReusablePackageView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct ReusablePackageView: View {
    var package: Package
    let screenSize: CGSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                let urlString = self.package.imagesCollection.first ?? ""
                let url = URL(string: urlString)
                self.checkPhaseImageView(for: url)
                self.isFavoriteButtonView
            }
            VStack(alignment: .leading, spacing: TravelinDesignSystem.DesignTokens.Spacing.small) {
                self.namePackageView
                self.rankingView
                self.descriptionPackageView
            }
            .frame(width: self.screenSize.width * 0.6, alignment: .leading)
            .padding()
        }
        .frame(width: self.screenSize.width * 0.6, alignment: .leading)
    }
    @ViewBuilder
    private func checkPhaseImageView(for url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: self.screenSize.width * 0.6, height: self.screenSize.width * 0.7)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding(TravelinDesignSystem.DesignTokens.Spacing.mediumLarge)
                    .foregroundStyle(TravelinDesignSystem.DesignTokens.Colors.secondaryButtonText)
                
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: self.screenSize.width * 0.6, height: self.screenSize.width * 0.7)
        .clipped()
        .overlay(TravelinDesignSystem.DesignTokens.Colors.darkButtonBackgroundPressed.opacity(0.2))
        .clipShape(RoundedCorner(radius: TravelinDesignSystem.DesignTokens.Spacing.mediumSmall, corners: [.topLeft, .topRight]))
    }
    private var isFavoriteButtonView: some View {
        Button {
            
        } label: {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: TravelinDesignSystem.DesignTokens.Spacing.large))
                .symbolRenderingMode(.palette)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(self.package.isFavorite ? .yellow : .black, .white)
        }
        .padding()
    }
    private var namePackageView: some View {
        Text(self.package.name)
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title1)
            .bold()
    }
    private var rankingView: some View {
        HStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium)
                    .foregroundStyle(self.package.rating >= index + 1 ? .yellow : .gray)
                
            }
            Text("\(self.package.numberReviews)")
                .font(TravelinDesignSystem.DesignTokens.Typography.title2)
                .foregroundStyle(.primary)
                .padding(.leading)
            
            Text(" reviews")
                .font(TravelinDesignSystem.DesignTokens.Typography.title2)
                .foregroundStyle(.primary)
        }
    }
    private var descriptionPackageView: some View {
        Text(self.package.description)
            .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium)
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
}

#Preview {
    ReusablePackageView(
        package: Package(
            id: "01",
            imagesCollection: ["package1"],
            name: "Koh Rong Samloem",
            rating: 4,
            numberReviews: 90,
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
        ), screenSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width )
    )
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath)
    }
}


enum Constants {
    static let cornerRadius: CGFloat = 12
    static let overlayOpacity: CGFloat = 0.13
    static let textPadding: CGFloat = 16
}
