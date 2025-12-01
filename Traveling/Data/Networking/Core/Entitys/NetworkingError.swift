//
//  NetworkingError.swift
//  TestNetworking
//
//  Created by Rodolfo Gonzalez on 27-11-25.
//

import Foundation

enum NetworkingError: Error, Equatable {
    
    // MARK: - EndPointBuilder Errors
    case invalidURL(URLError)
    
    // MARK: - RequestBuilder Errors
    case requestBuildingFailed(String)
    
    // MARK: - PayloadBuilder Errors
    case encodingFailed(Error)
    
    // MARK: - NetworkClient Errors
    case noConnection
    case timeout
    case transportError(URLError)
    
    // MARK: - NetworkService Errors
    case serverError(code: Int, message: String? = nil)
    case decodingFailed(Error)
    case invalidContentType
    case emptyResponse
    
    // MARK: - Repository Errors
    /// Este caso se propaga desde NetworkService
    /// Repository solo propaga NetworkingError
    
    // MARK: - Generic/Unknown
    case unknown(Error?)
    
}

// MARK: - Equatable Conformance
extension NetworkingError {
    static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        switch (lhs, rhs) {
            
        case (.invalidURL(let lErr), .invalidURL(let rErr)):
            return lErr == rErr
            
        case (.noConnection, .noConnection):
            return true
            
        case (.timeout, .timeout):
            return true
            
        case (.invalidContentType, .invalidContentType):
            return true
            
        case (.emptyResponse, .emptyResponse):
            return true
            
        case (.requestBuildingFailed(let lMsg), .requestBuildingFailed(let rMsg)):
            return lMsg == rMsg
            
        case (.encodingFailed, .encodingFailed):
            return true
            
        case (.transportError(let lErr), .transportError(let rErr)):
            return lErr.code == rErr.code
            
        case (.serverError(let lCode, _), .serverError(let rCode, _)):
            return lCode == rCode
            
        case (.decodingFailed, .decodingFailed):
            return true
            
        case (.unknown, .unknown):
            return true
            
        default:
            return false
        }
    }
}



// MARK: - Error Descriptions (útil para debugging y UI)
extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL(let urlError):
            return "Invalid URL: \(urlError.localizedDescription)"
            
        case .noConnection:
            return "No internet connection available"
            
        case .timeout:
            return "Request timed out"
            
        case .invalidContentType:
            return "Invalid content type in response"
            
        case .emptyResponse:
            return "Server returned empty response"
            
        case .requestBuildingFailed(let message):
            return "Failed to build request: \(message)"
            
        case .encodingFailed(let error):
            return "Failed to encode payload: \(error.localizedDescription)"
            
        case .transportError(let urlError):
            return "Transport error: \(urlError.localizedDescription)"
            
        case .serverError(let code, let message):
            if let message = message {
                return "Server error (\(code)): \(message)"
            }
            return "Server error with code: \(code)"
            
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
            
        case .unknown(let error):
            if let error = error {
                return "Unknown error: \(error.localizedDescription)"
            }
            return "Unknown error occurred"
        }
    }
}
