//
//  API Router.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case searchRepositories(query: String, page: Int)
    
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
        case .searchRepositories(let query, let page):
            return ["q": query, "sort": "stars", "order": "desc", "page": page, "per_page": 10]
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
