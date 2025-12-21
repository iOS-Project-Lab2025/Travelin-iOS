//
//  ReusablePackageView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct ReusablePackageView: View {
    var package: Package
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(package.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.width * 0.65)
                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                Button {
                    
                } label: {
                    Image(systemName: "heart.circle.fill")
                        .symbolRenderingMode(.palette)   // Permite usar varios colores
                        .foregroundStyle(package.isFavorite ? .yellow : .black, .white)
                            .symbolRenderingMode(.hierarchical)
                    // Un color por capa
                        .font(.system(size: 32))
                        .padding()
                }
            }
            VStack {
                Text(package.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .font(.system(size: 20))
                HStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .foregroundStyle(package.rating >= index + 1 ? .yellow : .gray)
                            .font(.system(size: 14))
                    }
                    Text("\(package.numberReviews)")
                        .padding(.leading)
                    
                    Text(" reviews")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(package.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity)
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
            servicesIncluded: ServicesIncluded(id: UUID(), title: "Bus", subTitle: "Transportation", icon: "bus.fill")
        )
    )
}
