//
//  RepositorySearchResult.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation

struct RepositorySearchResult: Codable {
    let totalCount: Int
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
