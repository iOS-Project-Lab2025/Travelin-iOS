//
//  TourDetailView.swift
//  Traveling
//
//  Created by Daniel Retamal on 04-01-26.
//

import SwiftUI

struct TourDetailView: View {
    let tour: Tour
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.PathRouter<BookingRoutes>.self) private var router
    @State private var isFavorite = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero Image with Header
                    heroImageSection
                    
                    // Tour Name and Reviews
                    nameAndReviewsSection
                        .padding(.horizontal, 26)
                        .padding(.top, -69)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 40) {
                        // About Section
                        aboutSection
                        
                        Divider()
                            .frame(height: 1)
                            .background(Color.black.opacity(0.1))
                        
                        // What's Included Section
                        whatsIncludedSection
                        
                        Divider()
                            .frame(height: 1)
                            .background(Color.black.opacity(0.1))
                        
                        // Photos Gallery
                        photosGallerySection
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    .padding(.bottom, 140)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // Bottom Action Bar
            VStack(spacing: 0) {
                bottomActionBar
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Hero Image Section
    private var heroImageSection: some View {
        ZStack(alignment: .top) {
            // Background Image with Gradient
            ZStack(alignment: .bottom) {
                Color.gray.opacity(0.3)
                    .frame(height: 428)
                
                // Main Image - Shows the first tour image (same as in the list)
                if let firstImageURL = tour.images.first, let url = URL(string: firstImageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: UIScreen.main.bounds.width, height: 428)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 428)
                                .clipped()
                        case .failure:
                            // Fallback if the image fails to load
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.gray.opacity(0.5),
                                            Color.blue.opacity(0.3)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: UIScreen.main.bounds.width, height: 428)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 428)
                    .clipped()
                } else {
                    // Placeholder if there are no images
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.gray.opacity(0.5),
                                    Color.blue.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: UIScreen.main.bounds.width, height: 428)
                }
                
                // Gradient Overlay
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.black.opacity(0), location: 0.67),
                        .init(color: Color.black.opacity(0.576), location: 0.94)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 428)
                
                // +Photos Button
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Text("+\(tour.totalPhotos) Photos")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(6)
                    }
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 16)
            }
            
            // Header with Back, Share and Favorite
            HStack {
                Button(action: { 
                    // When going back from tour detail, return to home
                    AppRouter.Main.shared.goTo(.home)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { isFavorite.toggle() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(isFavorite ? .red : .white)
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 26)
            .padding(.top, 50)
        }
    }
    
    // MARK: - Name and Reviews Section
    private var nameAndReviewsSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(tour.name)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 10) {
                // Star Rating
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(tour.rating) ? "star.fill" : "star")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                    }
                }
                
                Text(". \(tour.reviewsCount) reviews")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(tour.description)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .lineLimit(4)
                
                Button(action: {}) {
                    Text("Read all")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                        .underline()
                }
                .padding(.top, 8)
            }
        }
    }
    
    // MARK: - What's Included Section
    private var whatsIncludedSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What is included")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            VStack(spacing: 11) {
                HStack(spacing: 10) {
                    // Transportation Card
                    IncludedItemCard(
                        icon: "bus.fill",
                        title: tour.transportation,
                        subtitle: "Transportation"
                    )
                    
                    // Duration Card
                    IncludedItemCard(
                        icon: "clock.fill",
                        title: tour.duration,
                        subtitle: "Duration"
                    )
                }
                
                // Product Code Card
                IncludedItemCard(
                    icon: "qrcode",
                    title: tour.productCode,
                    subtitle: "Product code",
                    fullWidth: true
                )
            }
        }
    }
    
    // MARK: - Photos Gallery Section
    private var photosGallerySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Only show gallery if there's more than 1 image (first one is already in the hero)
            if tour.images.count > 1 {
                HStack(spacing: 3) {
                    // Left Column - Shows images 2 and 3 if they exist
                    VStack(spacing: 3) {
                        // Second image (index 1)
                        if tour.images.count > 1, let url = URL(string: tour.images[1]) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 156, height: 143)
                                        .clipped()
                                        .cornerRadius(6)
                                default:
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 156, height: 143)
                                }
                            }
                        }
                        
                        // Third image (index 2) - Only if it exists
                        if tour.images.count > 2, let url = URL(string: tour.images[2]) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 156, height: 143)
                                        .clipped()
                                        .cornerRadius(6)
                                default:
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 156, height: 143)
                                }
                            }
                        }
                    }
                    
                    // Right Large Image - Only if there are 4 or more images
                    if tour.images.count > 3, let url = URL(string: tour.images[3]) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 289)
                                    .clipped()
                                    .cornerRadius(6)
                            default:
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 289)
                            }
                        }
                    }
                }
                
                // Button to see all photos - Only if there are more than 4 images
                if tour.totalPhotos > 4 {
                    let remainingPhotos = tour.totalPhotos - 4 // 4 = 1 hero + 3 galería
                    Button(action: {}) {
                        Text("See all +\(remainingPhotos) photos")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 156)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Bottom Action Bar
    private var bottomActionBar: some View {
        HStack(spacing: 0) {
            // Price
            HStack {
                Text("$\(Int(tour.price))")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "#0A7BAB"))
                + Text("/Person")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#0A7BAB"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .padding(.horizontal, 20)
            
            // Book Now Button
            Button(action: {
                router.goTo(.availableDate(tour))
            }) {
                Text("Book Now")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .padding(.horizontal, 20)
                    .background(Color(hex: "#0FA3E2"))
                    .cornerRadius(15)
            }
            .padding(.leading, 5)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 11)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 11.5, x: 0, y: -2)
    }
}

// MARK: - Included Item Card Component
struct IncludedItemCard: View {
    let icon: String
    let title: String
    let subtitle: String
    var fullWidth: Bool = false
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .frame(width: 21, height: 21)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            if !fullWidth {
                Spacer()
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 9)
        .frame(maxWidth: fullWidth ? .infinity : nil, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue:  Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TourDetailView(tour: .mockTour)
    }
}
