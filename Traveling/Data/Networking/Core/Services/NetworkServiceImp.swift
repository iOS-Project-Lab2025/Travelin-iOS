//
//  NetworkService.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 19-11-25.
//

import Foundation

final class NetworkServiceImp: NetworkServiceProtocol {
    
    private let client: NetworkClientProtocol
    private let requestBuilder: RequestBuilderProtocol
    private let decoder: JSONDecoder
    
    init(client: NetworkClientProtocol,
         requestBuilder: RequestBuilderProtocol,
         decoder: JSONDecoder = JSONDecoder()
    ) {
        self.client = client
        self.requestBuilder = requestBuilder
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func execute<T: Decodable>(
        _ endPoint: any EndPointProtocol,
        responseType: T.Type,
        body: Encodable? = nil
    ) async throws -> T {
        
        let request = try self.requestBuilder.buildRequest(from: endPoint, body: body)
        
        // -------------------------------------------------------------
        // 🟦 LOG PROFESIONAL DE LA REQUEST (siempre se imprime)
        // -------------------------------------------------------------
        print("🌍 NETWORK REQUEST")
        print("➡️ URL:", request.url?.absoluteString ?? "NO URL")
        print("➡️ METHOD:", request.httpMethod ?? "NO METHOD")
        
        if let headers = request.allHTTPHeaderFields {
            print("➡️ HEADERS:", headers)
        }
        
        if let body = request.httpBody,
           let json = String(data: body, encoding: .utf8) {
            print("➡️ BODY:", json)
        } else {
            print("➡️ BODY: <empty>")
        }
        
        print("-----------------------------------------------------")
        
        do {
            
            let (data, response) = try await self.client.execute(request)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkingError.transportError(URLError(.badServerResponse))
            }
            
            
            // REEMPLAZAR el switch de status codes por:
            switch http.statusCode {
            case 200..<300:
                if let contentType = http.value(forHTTPHeaderField: "Content-Type") {
                    print("📦 Content-Type recibido: '\(contentType)'")
                } else {
                    print("⚠️ No se recibió Content-Type header")
                }
                // Validación más permisiva
                if let contentType = http.value(forHTTPHeaderField: "Content-Type"),
                   !contentType.isEmpty,
                   !contentType.lowercased().contains("json") { // ← Cambiado a "json" (más permisivo)
                    print("❌ Content-Type inválido: \(contentType)")
                    throw NetworkingError.invalidContentType
                }
                break
                
            case 400..<500:
                // Intentar parsear error del servidor
                let errorMessage = parseServerError(from: data) ?? "Client error"
                throw NetworkingError.serverError(
                    code: http.statusCode,
                    message: errorMessage
                )
                
            case 500..<600:
                let errorMessage = parseServerError(from: data) ?? "Server error"
                throw NetworkingError.serverError(
                    code: http.statusCode,
                    message: errorMessage
                )
                
            default:
                throw NetworkingError.transportError(URLError(.badServerResponse))
            }
            // Validar que data no esté vacía para respuestas exitosas
            guard !data.isEmpty else {
                throw NetworkingError.emptyResponse
            }
            
            
            
            // MARK: Decode
            do {
                return try self.decoder.decode(T.self, from: data)
            } catch {
                throw NetworkingError.decodingFailed(error)
            }
            
            // MARK: - NetworkingError Handling (primero - más específico)
        } catch let networkingError as NetworkingError {
            // Re-lanzar errores de networking tal cual
            throw networkingError
            
            // MARK: - URLError Mapping (segundo)
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                throw NetworkingError.noConnection
            case .timedOut:
                throw NetworkingError.timeout
            default:
                throw NetworkingError.transportError(urlError)
            }
            
            // MARK: - Unknown Error (último - menos específico)
        } catch {
            throw NetworkingError.unknown(error)
        }
    }
    // AGREGAR función helper:
    private func parseServerError(from data: Data) -> String? {
        guard let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: data) else {
            return nil
        }
        return errorResponse.message
    }
}
