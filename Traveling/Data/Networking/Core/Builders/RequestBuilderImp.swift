//
//  RequestBuilder.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

struct RequestBuilderImp: RequestBuilderProtocol {

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

        let url = try self.endPointBuilder.buildURL(from: endPoint)
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
            guard payloadBuilder != nil else {
                throw NetworkingError.requestBuildingFailed(
                    "PayloadBuilder is required when body is present"
                )
            }
            request.httpBody = try self.payloadBuilder?.buildPayload(from: body)
        }
        request.timeoutInterval = 30
        return request
    }
}
