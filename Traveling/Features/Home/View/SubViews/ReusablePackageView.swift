//
//  ReusablePackageView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct ReusablePackageView: View {
    var package: Package
    let size: CGSize

    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(package.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .overlay(Color.black.opacity(Constants.overlayOpacity))
                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                Button {

                } label: {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 32))
                        .symbolRenderingMode(.palette)   // Permite usar varios colores

                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(package.isFavorite ? .yellow : .black, .white)
                    // Un color por capa

                }
                .padding()
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(package.name)
                    .foregroundStyle(.primary)

                    .font(.system(size: 20, weight: .bold))
                HStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(package.rating >= index + 1 ? .yellow : .gray)

                    }
                    Text("\(package.numberReviews)")
                        .font(.system(size: 16))
                        .foregroundStyle(.primary)
                        .padding(.leading)

                    Text(" reviews")
                        .font(.system(size: 16))
                        .foregroundStyle(.primary)
                }

                Text(package.description)

                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

        }
    }
}

#Preview {
    ReusablePackageView(
        package: Package(
            id: UUID(),
            imageURL: "package1",
            imagesCollection: [],
            name: "Koh Rong Samloem",
            rating: 4,
            numberReviews: 90,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
        ), size: CGSize(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.55)
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
