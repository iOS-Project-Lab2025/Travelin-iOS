import Foundation

actor AuthInterceptor: RequestInterceptor {
    
    private let tokenManager: TokenManaging
    private var isRefreshing = false
    
    init(tokenManager: TokenManaging) {
        self.tokenManager = tokenManager
    }
    
    // MARK: - Adaptación
    func adapt(_ request: URLRequest) async -> URLRequest {
        var modifiedRequest = request
        
        // Si ya tenemos un token, lo inyectamos
        if let token = tokenManager.getAccessToken() {
            // Ojo: No sobrescribir si ya tiene un Authorization header (útil para endpoints públicos o especiales)
            if modifiedRequest.value(forHTTPHeaderField: "Authorization") == nil {
                modifiedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        return modifiedRequest
    }
    
    // MARK: - Lógica de Reintento (Refresh Token)
    func shouldRetry(_ request: URLRequest, with error: Error, response: HTTPURLResponse?) async -> RetryResult {
        
        // 1. Solo nos importa el error 401
        guard response?.statusCode == 401 else {
            return .doNotRetry
        }
        
        // 2. Evitar bucle infinito: Si la petición que falló YA ERA la de auth/refresh, no reintentar
        if let urlString = request.url?.absoluteString, urlString.contains("/auth/refresh") || urlString.contains("/auth/login") {
            return .doNotRetry
        }
        
        // 3. Si ya estamos refrescando, espera un poco y dile que reintente (usará el nuevo token)
        if isRefreshing {
            try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // Espera simple
            return .retry
        }
        
        // 4. Iniciar proceso de refresco
        isRefreshing = true
        defer { isRefreshing = false } // Asegurar que se libere el flag
        
        do {
            // A. Obtener el refresh token actual
            guard let refreshToken = tokenManager.getRefreshToken() else {
                // Si no hay refresh token, el usuario debe loguearse de nuevo
                return .doNotRetry
            }
            
            // B. Llamar al endpoint de refresco.
            // IMPORTANTE: Aquí deberías usar una llamada "cruda" o un cliente sin este interceptor
            // para evitar recursividad. Asumiremos una función auxiliar `performRefresh`.
            let newTokens = try await performTokenRefresh(using: refreshToken)
            
            // C. Guardar los nuevos tokens
            try tokenManager.saveTokens(newTokens)
            
            // D. Indicar que se debe reintentar la petición original
            return .retry
            
        } catch {
            // Si falla el refresco (ej. refresh token expirado), borramos todo
            tokenManager.clearTokens()
            return .doNotRetryWithError(error)
        }
    }
    
    // MARK: - Auxiliar para llamar a la API
    private func performTokenRefresh(using refreshToken: String) async throws -> OAuthTokens {
        // Construye tu request de refresco manual aquí para no pasar por el interceptor
        // Ejemplo simplificado:
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
        
        // Decodificar respuesta a OAuthTokens
        // Ajusta esto a como tu backend devuelve el JSON
        struct TokenResponse: Decodable {
            let accessToken: String
            let refreshToken: String?
        }
        
        let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
        return OAuthTokens(accessToken: decoded.accessToken, refreshToken: decoded.refreshToken)
    }
}
