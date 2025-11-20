//
//  RequestInterceptor.swift
//  Traveling
//
//  Ubicación sugerida: Data/Networking/Core/Protocols/
//

import Foundation

/// Enum para decidir qué hacer tras un error
enum RetryResult {
    case retry              // Reintentar la petición
    case doNotRetry         // Devolver el error original
    case doNotRetryWithError(Error) // Devolver un nuevo error (ej. logout)
}

protocol RequestInterceptor {
    /// Modifica la petición antes de enviarla (ej. agregar headers)
    func adapt(_ request: URLRequest) async -> URLRequest
    
    /// Decide qué hacer si la petición falla (ej. si es 401, refrescar y reintentar)
    func shouldRetry(_ request: URLRequest, with error: Error, response: HTTPURLResponse?) async -> RetryResult
}
