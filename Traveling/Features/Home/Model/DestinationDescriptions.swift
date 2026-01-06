//
//  DestinationDescriptions.swift
//  Traveling
//
//  Created by Daniel Retamal on 06-01-26.
//

import Foundation

/// Provides localized descriptions and metadata for destinations
/// used when displaying POI packages in the app.
struct DestinationDescriptions {
    
    /// Collection of engaging descriptions for various destination types
    private static let descriptions: [String] = [
        "Discover a natural paradise with stunning landscapes and rich biodiversity that will take your breath away.",
        "Immerse yourself in local history and culture by exploring colonial architecture and ancestral traditions.",
        "Experience a unique adventure with extreme sports and activities in a spectacular setting.",
        "Relax on white sandy beaches and crystal-clear waters perfect for rest and disconnection.",
        "Explore majestic mountains and trails offering unforgettable panoramic views.",
        "Enjoy authentic local cuisine in traditional restaurants and markets full of flavor.",
        "Meet wildlife in their natural habitat with tours guided by local experts.",
        "Navigate calm waters and discover paradisiacal islands with unique ecosystems.",
        "Experience the vibrant nightlife and cosmopolitan atmosphere of this fascinating city.",
        "Visit ancient archaeological sites that reveal the secrets of ancient civilizations.",
        "Tour green valleys and picturesque villages where time seems to stand still.",
        "Venture into the tropical jungle and discover hidden waterfalls and exotic wildlife.",
        "Practice water sports in a destination recognized worldwide for its perfect waves.",
        "Contemplate magical sunsets from natural viewpoints with 360-degree views.",
        "Stay in boutique accommodations that combine comfort with local authenticity.",
        "Participate in cultural festivals filled with music, dance, and traditional artistic expressions.",
        "Walk ecological trails designed to preserve the environment and educate visitors.",
        "Rest in natural hot springs surrounded by forests and mountains.",
        "Observe the stars in one of the cleanest and clearest skies on the continent.",
        "Explore underground caves with ancient rock formations and underground rivers.",
        "Experience the thrill of responsible ecotourism in protected natural reserves.",
        "Savor premium wines in family vineyards with exclusive tasting tours.",
        "Practice yoga and meditation in retreats designed for your integral well-being.",
        "Photograph unique landscapes that look like they came from a postcard or fairy tale.",
        "Connect with local communities and learn about their customs and sustainable way of life."
    ]
    
    /// Generates a random description from the available pool
    static func randomDescription() -> String {
        descriptions.randomElement() ?? descriptions[0]
    }
    
    /// Generates a random rating between 3 and 5 stars
    static func randomRating() -> Int {
        Int.random(in: 3...5)
    }
    
    /// Generates a random number of reviews based on rating
    /// Higher ratings tend to have more reviews
    static func randomReviews(for rating: Int) -> Int {
        switch rating {
        case 5:
            return Int.random(in: 50...150)
        case 4:
            return Int.random(in: 25...80)
        case 3:
            return Int.random(in: 10...40)
        default:
            return Int.random(in: 5...20)
        }
    }
    
    /// Generates consistent metadata for a given POI ID
    /// Uses the ID as seed to ensure the same POI always gets the same data
    static func metadata(for poiID: String) -> (description: String, rating: Int, reviews: Int) {
        // Use POI ID hash as seed for consistent randomization
        var hasher = Hasher()
        hasher.combine(poiID)
        let seed = abs(hasher.finalize())
        
        // Generate consistent pseudo-random values
        let descriptionIndex = seed % descriptions.count
        let description = descriptions[descriptionIndex]
        
        // Rating between 3-5
        let rating = 3 + (seed / 100) % 3
        
        // Reviews based on rating
        let reviews: Int
        switch rating {
        case 5:
            reviews = 50 + (seed % 101)
        case 4:
            reviews = 25 + (seed % 56)
        case 3:
            reviews = 10 + (seed % 31)
        default:
            reviews = 5 + (seed % 16)
        }
        
        return (description, rating, reviews)
    }
}
