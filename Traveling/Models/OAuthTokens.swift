//
//  oauth.swift
//  Traveling
//
//  Created by NVSH on 29-10-25.
//

import Foundation

/// A simple data structure to hold and transport OAuth2 authentication tokens.
///
/// This is a value-type (`struct`) because tokens represent a snapshot of
/// credentials at a specific moment and don't have a persistent identity.
struct OAuthTokens: Codable {
    /// The short-lived token used to authenticate API requests.
    let accessToken: String

    /// The long-lived token used to obtain a new `accessToken` when it expires.
    ///
    /// This is optional because not all OAuth2 flows (e.g., Client Credentials)
    /// provide a refresh token.
    let refreshToken: String?
}
