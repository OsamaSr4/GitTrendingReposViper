//
//  Owner.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation

struct Owner: Codable {
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
