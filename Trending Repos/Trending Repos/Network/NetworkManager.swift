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
    
    init(timeoutInterval: TimeInterval = 60.0, decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        self.session = Session(configuration: configuration)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Codable>(_ target: URLRequestConvertible) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            print("Target",target)
            session.request(target).validate().responseDecodable(of: T.self) { response in
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
