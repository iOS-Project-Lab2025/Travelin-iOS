//
//  APIResponse.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

struct APIResponse<D: Decodable> {
    let statusCode: HTTPStatusCode
    let result: Result<D?, HTTPError>
}
