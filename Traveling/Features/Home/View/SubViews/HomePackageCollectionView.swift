//
//  HomePackageCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct HomePackageCollectionView: View {
    @Binding var packages: [Package]
    let items = Array(1...20)
    
    // Define las filas del grid
    let rows = [
        GridItem(.fixed(UIScreen.main.bounds.width * 0.65)),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Popular package in asia")
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                .font(.system(size: 22))
                .padding(.leading)
                .padding(.top, 24)
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: rows, spacing: 16) {
                    ForEach(packages) { package in
                        ReusablePackageView(package: package)
                            .frame(width: UIScreen.main.bounds.width * 0.65)
                    }
                }
                .padding()
            }
        }
    }
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
#Preview {
    HomePackageCollectionView(packages: .constant([
        Package(
            id: UUID(),
            imageURL: "package1",
            imagesCollection: [],
            name: "Koh Rong Samloem",
            rating: 3,
            numberReviews: 50,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: ServicesIncluded(id: UUID(), title: "Bus", subTitle: "Transportation", icon: "bus.fill")
        ), Package(
            id: UUID(),
            imageURL: "package1",
            imagesCollection: [],
            name: "Koh Rong Samloem",
            rating: 4,
            numberReviews: 90,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: ServicesIncluded(id: UUID(), title: "Bus", subTitle: "Transportation", icon: "bus.fill")
        )
    ])
    )
}
