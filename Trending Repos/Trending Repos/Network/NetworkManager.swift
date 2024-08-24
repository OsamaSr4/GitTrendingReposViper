//
//  NetworkManager.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation
import Alamofire

protocol NetworkManaging {
    func request<T: Codable>(_ target: URLRequestConvertible) async throws -> T
}

class NetworkManager: NetworkManaging {
    private let session: Session
    private let decoder: JSONDecoder
    
    init(session: Session = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Codable>(_ target: URLRequestConvertible) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            print("Target",target)
            session.request(target).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(with: .success(value))
                case .failure(let error):
                    print("Request error:", error)
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}
