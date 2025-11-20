//
//  NetworkClient.swift
//  Traveling
//
//  Created by Daniel Retamal on 18-11-25.
//

import Foundation

class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let interceptor: RequestInterceptor? // Inyectado
    
    init(session: URLSession = .shared, interceptor: RequestInterceptor? = nil) {
        self.session = session
        self.interceptor = interceptor
    }
    
    func execute(_ request: URLRequest) async throws -> Data {
        // 1. Adaptar (inyectar token)
        var finalRequest = request
        if let interceptor = interceptor {
            finalRequest = await interceptor.adapt(request)
        }
        
        // 2. Ejecutar
        do {
            let (data, response) = try await session.data(for: finalRequest)
            
            // 3. Verificar si es 401 para interceptar
            if let httpResponse = response as? HTTPURLResponse, 
               httpResponse.statusCode == 401, 
               let interceptor = interceptor {
                
                // Preguntar al interceptor qué hacer
                let action = await interceptor.shouldRetry(
                    finalRequest, 
                    with: URLError(.userAuthenticationRequired), 
                    response: httpResponse
                )
                
                switch action {
                case .retry:
                    // RECURSIVIDAD: Llamar a execute de nuevo.
                    // Al entrar, el interceptor.adapt() cogerá el token NUEVO que se acaba de guardar.
                    return try await execute(request) // Nota: usa 'request' original sin headers sucios
                    
                case .doNotRetry:
                    // Retornar data tal cual (el llamador debe manejar el 401)
                    return data
                    
                case .doNotRetryWithError(let error):
                    // El interceptor decidió lanzar un error diferente (ej. refresh falló)
                    throw error
                }
            }
            
            // 4. Si no es 401, devolver data normalmente
            return data
            
        } catch let error as URLError {
            // Si es un error de red (timeout, sin conexión), propagarlo directamente
            throw error
        } catch {
            // Otros errores (ej. decodificación), propagarlos
            throw error
        }
    }
}
