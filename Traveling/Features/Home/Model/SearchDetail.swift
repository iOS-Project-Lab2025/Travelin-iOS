//
//  SearchDetail.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 05-01-26.
//

import Foundation

struct SearchDetail {
    var searchText: String = ""
    var searchType: SearchType = .all
}
enum SearchType {
    case all
    case hotel
    case oversea
}
