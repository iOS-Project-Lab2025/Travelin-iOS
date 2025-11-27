//
//  RequestBuilderProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

protocol RequestBuilderProtocol {
    func buildRequest(from endpoint: EndPointProtocol, body: Encodable?) throws -> URLRequest
}
