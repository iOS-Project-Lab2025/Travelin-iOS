//
//  RequestBuilder.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

struct RequestBuilder: RequestBuilderProtocol {

    private let endPointBuilder: EndPointBuilderProtocol
    private let payloadBuilder: PayloadBuilderProtocol

    init(endPointBuilder: EndPointBuilderProtocol,
         payloadBuilder: PayloadBuilderProtocol) {
        self.endPointBuilder = endPointBuilder
        self.payloadBuilder = payloadBuilder
    }

    func buildRequest<E: Encodable>(
        from endPoint: any EndPoint,
        body: E?
    ) throws -> URLRequest {

        // 1. Construye la URL
        let url = try endPointBuilder.buildURL(from: endPoint)

        // 2. Crea la request base
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue

        // 3. Headers (correctamente tipados)
        if let headers = endPoint.headers {
            request.allHTTPHeaderFields = headers
        }

        // 4. Body (si existe)
        if let body = body {
            request.httpBody = try payloadBuilder.buildPayload(from: body)
        }

        request.timeoutInterval = 30
        return request
    }
}
