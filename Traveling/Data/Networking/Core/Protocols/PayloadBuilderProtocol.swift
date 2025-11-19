//
//  PayloadBuilderProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

protocol PayloadBuilderProtocol {
    func buildPayload<E: Encodable>(from model: E) throws -> Data
}
