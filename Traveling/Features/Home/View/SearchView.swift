//
//  SearchView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 30-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct SearchView: View {
    @FocusState private var focused: Bool
    @Binding var packages: [Package]
    @Binding var inputText: String
    @Binding var router: AppRouter.FlowRouter<HomeRoutes>
    let size: CGSize

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Contenido
                if inputText.isEmpty {
                    NearbySearchComponentView()
                } else {
                    VStack(alignment: .leading) {
                        ReusablePackageSearchView(inputText: $inputText, packages: $packages, size: size)

                        if packages.count > 3 {
                            Button { } label: {
                                Text("Show + \(packages.count - 3) more available")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 14, weight: .bold))
                                    .frame(width: size.width * 0.5)
                                    .padding(.vertical, 12)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.35), lineWidth: 2)
                                    .padding(.horizontal, 16)
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .onAppear() {
                focused = true
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)   // ✅ el teclado no empuja
        .navigationBarHidden(true)                    // ✅ apaga navbar sistema

        // ✅ Header fijo que respeta safe area
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button {
                        router.previous()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)

                    DSTextField(
                        symbolPosition: inputText.isEmpty ? .left : .right,
                        placeHolder: inputText.isEmpty ? "Where do you plan to go?" : "",
                        type: .search,
                        style: .outlined,
                        text: $inputText
                    )
                    .focused($focused)

                    if !inputText.isEmpty {
                        Image(systemName: "square.grid.3x2.fill")
                            .font(.system(size: 16))
                            .rotationEffect(.degrees(90))
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1 / UIScreen.main.scale)
            }
        }
    }
}


#Preview {
    NavigationStack {
        SearchView(packages: .constant([
            Package(
                id: "01",
                imagesCollection: ["package1"],
                name: "Koh Rong Samloem",
                rating: 3,
                numberReviews: 50,
                description: "Lorem ipsum dolor sit amet...",
                isFavorite: true,
                price: 600,
                servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
            ), Package(
                id: "02",
                imagesCollection: ["package1"],
                name: "Koh Rong Samloem",
                rating: 4,
                numberReviews: 90,
                description: "Lorem ipsum dolor sit amet...",
                isFavorite: true,
                price: 600,
                servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
            ),
            Package(
                id: "03",
                imagesCollection: ["package1"],
                name: "Koh Rong Samloem",
                rating: 3,
                numberReviews: 50,
                description: "Lorem ipsum dolor sit amet...",
                isFavorite: true,
                price: 600,
                servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
            ),
            Package(
                id: "04",
                imagesCollection: ["package1"],
                name: "Koh Rong Samloem",
                rating: 4,
                numberReviews: 90,
                description: "Lorem ipsum dolor sit amet...",
                isFavorite: true,
                price: 600,
                servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
            )
        ]), inputText: .constant("s"), router: .constant(AppRouter.FlowRouter<HomeRoutes>(flow: [.home, .poiSearch, .poiDetail]))
                   , size: CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width * 0.38))
    }
}







struct NearbySearchComponentView: View {
    var body: some View {
        Button {
            
        } label: {
            VStack(spacing:0) {
                HStack(alignment: .center) {
                    Image(systemName: "drop.circle")
                        .font(.system(size: 32))
                        .symbolRenderingMode(.palette)   // Permite usar varios colores
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color.gray)
                    VStack(alignment: .leading) {
                        Text("Search place nearby")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold))
                        Text("Current location - Chile")
                            .foregroundStyle(.black)
                            .font(.system(size: 14, weight: .light))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Rectangle()
                    .fill(Color.gray.opacity(0.8))
                    .frame(height: 1 / UIScreen.main.scale)
                    .padding(.all)
            }
            // Un color por capa
        }
        .padding()
    }
}

struct ReusablePackageSearchView: View {
    @Binding var inputText: String
    @Binding var packages: [Package]
    let size: CGSize
    var body: some View {
        VStack {
            Text("Place name \"\(inputText)\" ")
                .foregroundStyle(.primary)
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
            LazyVStack(
                alignment: .center,
                spacing: 0) {
                    ForEach(Array(packages.prefix(3))) { package in
                        VStack {
                            HStack {
                                let urlString = package.imagesCollection.first ?? ""
                                let url = URL(string: urlString)

                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: size.width * 0.38, height: size.width * 0.38)

                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()

                                    case .failure(let error):
                                        Image(systemName: "photo")
                                            .onAppear { print("❌ Image error:", error.localizedDescription, urlString) }

                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: size.width * 0.38, height: size.width * 0.38)
                                .cornerRadius(15)
                                .clipped()
                                .overlay(Color.black.opacity(Constants.overlayOpacity))

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(package.name)
                                        .foregroundStyle(.primary)
                                    
                                        .font(.system(size: 20, weight: .bold))
                                        .lineLimit(2)
                                    HStack(spacing: 0) {
                                        ForEach(0..<5, id: \.self) { index in
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 14))
                                                .foregroundStyle(package.rating >= index + 1 ? .yellow : .gray)
                                            
                                        }
                                        Text("\(package.numberReviews)")
                                            .font(.system(size: 14))
                                            .foregroundStyle(.primary)
                                            .padding(.leading)
                                        
                                        Text(" reviews")
                                            .font(.system(size: 14))
                                            .foregroundStyle(.primary)
                                    }
                                    Text(package.description)
                                    
                                        .font(.system(size: 14))
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                    Text("from $\(package.price)/person ")
                                    
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 16, weight: .bold))
                                    Text(package.servicesIncluded.first!.title)
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(.all, 6)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                                        }
                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Rectangle()
                                .fill(Color.gray.opacity(0.8))
                                .frame(height: 1)
                                .frame(maxWidth:  size.width)
                                .padding(.vertical, 8)
                        }
                    }
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

