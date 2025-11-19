//
//  EndpointBuilderProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

protocol EndPointBuilderProtocol {
    func buildURL(from endPoint: EndPoint) throws -> URL
}
