//
//  AuthInterceptor.swift
//  Traveling
//
//  Created by Daniel Retamal on 18-11-25.
//

import Foundation

actor AuthInterceptor: RequestInterceptor {
    
    private let tokenManager: TokenManaging
    private var isRefreshing = false
    
    init(tokenManager: TokenManaging) {
        self.tokenManager = tokenManager
    }
    
    // MARK: - Adaptation
    func adapt(_ request: URLRequest) async -> URLRequest {
        var modifiedRequest = request
        
        // If we already have a token, inject it
        if let token = tokenManager.getAccessToken() {
            // Note: Don't overwrite if it already has an Authorization header (useful for public or special endpoints)
            if modifiedRequest.value(forHTTPHeaderField: "Authorization") == nil {
                modifiedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        return modifiedRequest
    }
    
    // MARK: - Retry Logic (Refresh Token)
    func shouldRetry(_ request: URLRequest, with error: Error, response: HTTPURLResponse?) async -> RetryResult {
        
        // 1. Only care about 401 errors
        guard response?.statusCode == 401 else {
            return .doNotRetry
        }
        
        // 2. Avoid infinite loop: If the request that failed WAS ALREADY auth/refresh, don't retry
        if let urlString = request.url?.absoluteString, urlString.contains("/auth/refresh") || urlString.contains("/auth/login") {
            return .doNotRetry
        }
        
        // 3. If we're already refreshing, wait a bit and tell it to retry (will use the new token)
        if isRefreshing {
            try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // Simple wait
            return .retry
        }
        
        // 4. Start refresh process
        isRefreshing = true
        defer { isRefreshing = false } // Ensure the flag is released
        
        do {
            // A. Get the current refresh token
            guard let refreshToken = tokenManager.getRefreshToken() else {
                // If there's no refresh token, the user must log in again
                return .doNotRetry
            }
            
            // B. Call the refresh endpoint.
            // IMPORTANT: Use a "raw" call or a client without this interceptor
            // to avoid recursion. We'll use a helper function `performRefresh`.
            let newTokens = try await performTokenRefresh(using: refreshToken)
            
            // C. Save the new tokens
            try tokenManager.saveTokens(newTokens)
            
            // D. Indicate that the original request should be retried
            return .retry
            
        } catch {
            // If refresh fails (e.g., refresh token expired), clear everything
            tokenManager.clearTokens()
            return .doNotRetryWithError(error)
        }
    }
    
    // MARK: - Helper to call the API
    private func performTokenRefresh(using refreshToken: String) async throws -> OAuthTokens {
        // Build your refresh request manually here to avoid going through the interceptor
        // Simplified example:
        guard let url = URL(string: "https://api.tuapp.com/auth/refresh") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["refreshToken": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Decode response to OAuthTokens
        // Adjust this to match how your backend returns the JSON
        struct TokenResponse: Decodable {
            let accessToken: String
            let refreshToken: String?
        }
        
        let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
        return OAuthTokens(accessToken: decoded.accessToken, refreshToken: decoded.refreshToken)
    }
}
