//
//  TourCardView.swift
//  Traveling
//
//  Created by Daniel Retamal on 04-01-26.
//

import SwiftUI

struct TourCardView: View {
    let tour: Tour
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                // Tour Image
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.3),
                                Color.purple.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 122, height: 122)
                    .overlay(
                        Text("📷")
                            .font(.system(size: 40))
                    )
                
                // Tour Info
                VStack(alignment: .leading, spacing: 8) {
                    // Tour Name
                    Text(tour.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Rating and Reviews
                    HStack(spacing: 10) {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(tour.rating) ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundColor(.yellow)
                            }
                        }
                        
                        Text("\(tour.reviewsCount) reviews")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    // Location
                    Text(tour.location)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    // Price
                    Text("from $\(Int(tour.price))/person")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    
                    // Duration Badge
                    Text(tour.duration)
                        .font(.system(size: 10))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12.5)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    VStack {
        TourCardView(tour: .mockTour) {
            print("Tour tapped")
        }
        
        TourCardView(tour: Tour.mockTours[1]) {
            print("Tour tapped")
        }
    }
    .padding()
}
