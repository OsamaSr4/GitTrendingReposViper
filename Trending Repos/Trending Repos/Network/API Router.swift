//
//  API Router.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation
import Alamofire

enum GitHubAPIRouter: URLRequestConvertible {
    case searchRepositories(query: String)
    
    var method: HTTPMethod {
        switch self {
        case .searchRepositories:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchRepositories:
            return "/search/repositories"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .searchRepositories(let query):
            return ["q": query]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try "https://api.github.com".asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.method = method
        request = try URLEncoding.default.encode(request, with: parameters)
        return request
    }
}
