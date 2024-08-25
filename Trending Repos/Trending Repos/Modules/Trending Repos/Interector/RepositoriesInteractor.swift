//
//  RepositoriesInteractor.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation

protocol RepositoriesInteractorInput {
    func fetchRepositories(query: String, page: Int)
}

protocol RepositoriesInteractorOutput: AnyObject {
    func didFetchRepositories(_ repositories: [Repository], hasMore: Bool)
    func didFailToFetchRepositories(with error: Error)
}

class RepositoriesInteractor: RepositoriesInteractorInput {
    weak var output: RepositoriesInteractorOutput?
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func fetchRepositories(query: String, page: Int) {
        Task {
            do {
                let result: RepositorySearchResult = try await networkManager.request(APIRouter.searchRepositories(query: query, page: page))
                let hasMore = result.items.count == 10 // Assuming 10 items per page
                output?.didFetchRepositories(result.items, hasMore: hasMore)
            } catch {
                output?.didFailToFetchRepositories(with: error)
            }
        }
    }
}
