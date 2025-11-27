//
//  URLSessionClient.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 19-11-25.
//

import Foundation

final class URLNetworkClient: NetworkClientProtocol {
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}



// Implementacion con Interceptors

/**
 final class NetworkClient: NetworkClientProtocol {
     private let session: URLSession
     private let interceptors: [RequestInterceptor]

     init(session: URLSession = .shared, interceptors: [RequestInterceptor] = []) {
         self.session = session
         self.interceptors = interceptors
     }

     func execute(_ request: URLRequest) async throws -> Data {
         var adaptedRequest = request
         for interceptor in interceptors {
             adaptedRequest = try await interceptor.adapt(adaptedRequest)
         }

         do {
             let (data, response) = try await session.data(for: adaptedRequest)
             guard let httpResponse = response as? HTTPURLResponse else {
                 throw NetworkError.invalidRequest
             }

             switch httpResponse.statusCode {
             case 200..<300:
                 return data
             case 401:
                 throw NetworkError.unauthorized
             case 408:
                 throw NetworkError.timeout
             default:
                 throw NetworkError.serverError(code: httpResponse.statusCode)
             }
         } catch {
             if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                 throw NetworkError.noInternet
             }
             throw NetworkError.unknown(error)
         }
     }
 }

 */
