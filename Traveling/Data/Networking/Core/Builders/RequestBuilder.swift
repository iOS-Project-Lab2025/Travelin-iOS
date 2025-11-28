//
//  RequestBuilder.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

struct RequestBuilder: RequestBuilderProtocol {

    private let endPointBuilder: EndPointBuilderProtocol
    private let payloadBuilder: PayloadBuilderProtocol?

    init(endPointBuilder: EndPointBuilderProtocol,
         payloadBuilder: PayloadBuilderProtocol? = nil) {
        self.endPointBuilder = endPointBuilder
        self.payloadBuilder = payloadBuilder
    }

    func buildRequest(
        from endPoint: any EndPointProtocol,
        body: Encodable? = nil
    ) throws -> URLRequest {

        let url = try endPointBuilder.buildURL(from: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        let commonHeaders = [
            "Accept": "application/json",
            "App-Version": "1.0"
        ]
        var finalHeaders = commonHeaders
        if let endpointHeaders = endPoint.headers {
            for (key, value) in endpointHeaders {
                finalHeaders[key] = value
            }
        }
        request.allHTTPHeaderFields = finalHeaders
        if let body = body {
            request.httpBody = try payloadBuilder?.buildPayload(from: body)
        }
        request.timeoutInterval = 30
        return request
    }
}
