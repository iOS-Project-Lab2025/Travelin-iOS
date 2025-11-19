//
//  RequestBuilderProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

protocol RequestBuilderProtocol {
    func buildRequest<E: Encodable>(
        from endpoint: EndPoint,
        body: E?
    ) throws -> URLRequest
}
