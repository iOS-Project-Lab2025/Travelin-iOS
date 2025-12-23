//
//  UserService.swift
//  Traveling
//
//  Created by Daniel Retamal on 03-12-25.
//

import Foundation

/// Service responsible for user-related operations that require authentication
/// Uses unified NetworkClient with interceptor for automatic token injection and refresh
class UserService {

    private let client: InterceptableNetworkClientProtocol
    private let requestBuilder: RequestBuilderProtocol

    init(client: InterceptableNetworkClientProtocol, requestBuilder: RequestBuilderProtocol) {
        self.client = client
        self.requestBuilder = requestBuilder
    }

    // MARK: - Get User Profile
    /// Fetches the current user's profile information
    /// - Returns: UserProfileResponse containing user data
    /// - Note: This endpoint requires authentication. The NetworkClient will automatically
    ///         inject the access token and handle token refresh if needed.
    func getUserProfile() async throws -> UserProfileResponse {
        let endpoint = UserEndpoint.me

        let request = try requestBuilder.buildRequest(
            from: endpoint,
            body: endpoint.bodyData
        )

        let data = try await client.execute(request)
        return try JSONDecoder().decode(UserProfileResponse.self, from: data)
    }
}

// MARK: - Response Models
struct UserProfileResponse: Codable {
    let data: UserProfileData

    struct UserProfileData: Codable {
        let user: UserInfo
    }

    struct UserInfo: Codable {
        let email: String
        let firstName: String?
        let lastName: String?
        let id: String?

        enum CodingKeys: String, CodingKey {
            case email
            case firstName = "first_name"
            case lastName = "last_name"
            case id
        }
    }
}
