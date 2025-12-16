//
//  NetworkingErrorTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

@Suite("NetworkingError Tests")
struct NetworkingErrorTests {

    // MARK: - Equatable Behavior

    @Test("Errors of the same type are considered equal")
    func sameErrorTypesAreEqual() {
        #expect(NetworkingError.noConnection == .noConnection)
        #expect(NetworkingError.timeout == .timeout)
        #expect(NetworkingError.invalidContentType == .invalidContentType)
        #expect(NetworkingError.emptyResponse == .emptyResponse)
    }

    @Test("Errors with associated values compare correctly")
    func associatedValuesCompareCorrectly() {
        let urlError1 = URLError(.badURL)
        let urlError2 = URLError(.badURL)
        let urlError3 = URLError(.cannotFindHost)

        #expect(NetworkingError.invalidURL(urlError1) == .invalidURL(urlError2))
        #expect(NetworkingError.invalidURL(urlError1) != .invalidURL(urlError3))

        #expect(
            NetworkingError.requestBuildingFailed("A")
            == NetworkingError.requestBuildingFailed("A")
        )

        #expect(
            NetworkingError.requestBuildingFailed("A")
            != NetworkingError.requestBuildingFailed("B")
        )
    }

    @Test("Server errors compare by status code only")
    func serverErrorsCompareByCode() {
        let errorA = NetworkingError.serverError(code: 500, message: "Internal")
        let errorB = NetworkingError.serverError(code: 500, message: "Different message")
        let errorC = NetworkingError.serverError(code: 404, message: "Not found")

        #expect(errorA == errorB)
        #expect(errorA != errorC)
    }

    @Test("Errors with wrapped errors ignore underlying error identity")
    func wrappedErrorsCompareByCaseOnly() {
        let err1 = NSError(domain: "X", code: 1)
        let err2 = NSError(domain: "Y", code: 2)

        #expect(NetworkingError.encodingFailed(err1) == .encodingFailed(err2))
        #expect(NetworkingError.decodingFailed(err1) == .decodingFailed(err2))
        #expect(NetworkingError.unknown(err1) == .unknown(err2))
    }

    // MARK: - LocalizedError Descriptions

    @Test("Provides meaningful error descriptions")
    func providesErrorDescriptions() {
        let invalidURL = NetworkingError.invalidURL(URLError(.badURL))
        #expect(invalidURL.errorDescription?.contains("Invalid URL") == true)

        let noConnection = NetworkingError.noConnection
        #expect(noConnection.errorDescription == "No internet connection available")

        let timeout = NetworkingError.timeout
        #expect(timeout.errorDescription == "Request timed out")
    }

    @Test("Server error description includes code and optional message")
    func serverErrorDescription() {
        let withMessage = NetworkingError.serverError(code: 500, message: "Internal Server Error")
        let withoutMessage = NetworkingError.serverError(code: 500)

        #expect(withMessage.errorDescription?.contains("500") == true)
        #expect(withMessage.errorDescription?.contains("Internal Server Error") == true)

        #expect(withoutMessage.errorDescription?.contains("500") == true)
    }

    @Test("Unknown error description behaves correctly")
    func unknownErrorDescription() {
        let wrapped = NetworkingError.unknown(URLError(.unknown))
        let plain = NetworkingError.unknown(nil)

        #expect(wrapped.errorDescription?.contains("Unknown error") == true)
        #expect(plain.errorDescription == "An unknown error occurred")
    }

    // MARK: - Usability as Error

    @Test("NetworkingError can be used as Swift Error")
    func conformsToError() {
        let error: Error = NetworkingError.timeout
        #expect(error.localizedDescription.contains("timed out"))
    }

    // MARK: - Realistic Usage Scenario

    @Test("Errors can be pattern matched in catch blocks")
    func supportsPatternMatching() {
        let error: Error = NetworkingError.noConnection

        switch error {
        case NetworkingError.noConnection:
            #expect(true)
        default:
            Issue.record("Expected noConnection error")
        }
    }
}

