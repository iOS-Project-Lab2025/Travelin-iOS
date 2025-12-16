//
//  MockEndPoint.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 15-12-25.
//


@testable import Traveling
import Foundation

struct MockEndPoint: EndPointProtocol {
    var method: HTTPMethod
    
    var path: String
    
    var queryItems: [URLQueryItem]? = nil
    
    var headers: [String : String]? = nil
    
    
}

