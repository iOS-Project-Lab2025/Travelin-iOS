//
//  ReusablePackageView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct ReusablePackageView: View {
    /// Two-way model binding (favorite toggles propagate to the source list).
    /// Used in HomePackageCollectionView via ForEach($viewModel.allPoiPackages).
    /// Keep mutations minimal and UI-focused.
    @Binding var package: Package
    /// Used to compute proportional layout sizes for this card.
    /// Caller provides the available screen size (usually GeometryReader size).
    /// This makes the view responsive across devices.
       let screenSize: CGSize
    /// Optional tap action used by parent (e.g., navigate to detail).
    /// The entire card is wrapped in a Button that triggers this closure.
    /// If nil, the card becomes visually tappable but does nothing.
       var onTap: (() -> Void)? = nil
    
    var body: some View {
        /// Outer button: tapping the card triggers onTap (typically navigation).
        /// Content is a vertical card: image + details.
        /// Favorite is an overlay button inside the image area.
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    /// Uses only the first image URL string as the cover.
                    /// If empty/invalid, AsyncImage will hit failure or show placeholder.
                    /// URL parsing is intentionally lightweight here.
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
                /// Text container width matches card width for consistent layout.
                /// Tint is set to black to avoid inherited button tint affecting content.
                /// Padding follows the design system spacing.
                .padding()
                .frame(width: self.screenSize.width * 0.6, alignment: .leading)
                .tint(.black)
            }
            
        }
    }

    @ViewBuilder
    private func checkPhaseImageView(for url: URL?) -> some View {
        /// AsyncImage phase handler: loading, success, failure, unknown.
        /// Uses a fixed frame so the card doesn't "jump" while loading.
        /// Image is clipped and rounded only on the top corners.
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
        /// Nested button: toggles only the favorite state on the bound model.
        /// Uses plain style to avoid default button effects inside the card button.
        /// Icon switches between filled/outline with palette rendering.
        Button {
            package.isFavorite.toggle()  // ✅ Solo una vez
        } label: {
            Image(systemName: package.isFavorite ? "heart.circle.fill" : "heart.circle")
                .font(.system(size: TravelinDesignSystem.DesignTokens.Spacing.large))
                .symbolRenderingMode(.palette)
                .foregroundStyle(
                    package.isFavorite ? .yellow : .white,
                    package.isFavorite ? .white : .gray.opacity(0.5)
                )
        }
        .buttonStyle(.plain)  // ✅ Evita el estilo default
        .padding()
    }

    private var namePackageView: some View {
        /// Primary title text for the package.
        /// Uses design system typography and bold weight.
        /// Keeps color aligned with the system primary style.
        Text(self.package.name)
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title1)
            .bold()
    }

    private var rankingView: some View {
        /// Renders a 5-star rating row (integer-based).
        /// Stars are filled based on rating threshold; remainder are gray.
        /// Appends review count and label for clarity.
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
        /// Secondary description text (single-line preview).
        /// Uses design system body typography with secondary color.
        /// Line-limited to keep card height consistent.
        Text(self.package.description)
            .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium)
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
}

#Preview {
    /// Preview uses a constant binding with sample Package data.
    /// Screen size is derived from UIScreen to match runtime proportions.
    /// Helps validate layout, image rendering, and favorite icon states.
    ReusablePackageView(
        package: .constant(Package(
            id: "01",
            imagesCollection: ["package1"],
            name: "Koh Rong Samloem",
            rating: 4,
            numberReviews: 90,
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")],
            poiSource: POIDomainModel(
                id: "01",
                name: "Koh Rong Samloem",
                pictures: ["package1"],
                lat: 10.5,
                lon: 103.5,
                category: "BEACH_PARK"
            )
        )), screenSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width )
    )
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )
}

struct RoundedCorner: Shape {
    /// Utility shape to round only specific corners.
    /// Used by the image container to round top-left and top-right corners.
    /// Keeps card style consistent with the design system.
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




