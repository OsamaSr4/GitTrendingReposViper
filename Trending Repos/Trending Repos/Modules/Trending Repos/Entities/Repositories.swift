//
//  Repositories.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation

struct Repository: Codable {
    let name: String
    let owner: Owner
    let stargazersCount: Int
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case stargazersCount = "stargazers_count"
        case language
    }
}
