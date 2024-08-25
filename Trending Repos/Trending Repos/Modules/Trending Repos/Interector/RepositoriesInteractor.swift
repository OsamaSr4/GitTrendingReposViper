//
//  RepositoriesInteractor.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation

protocol RepositoriesInteractorInput {
    func fetchRepositories(query: String)
}

protocol RepositoriesInteractorOutput: AnyObject {
    func didFetchRepositories(_ repositories: [Repository])
    func didFailToFetchRepositories(with error: Error)
}

class RepositoriesInteractor: RepositoriesInteractorInput {
    weak var output: RepositoriesInteractorOutput?
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func fetchRepositories(query: String) {
        Task {
            do {
                let result: RepositorySearchResult = try await networkManager.request(GitHubAPIRouter.searchRepositories(query: query))
                output?.didFetchRepositories(result.items)
            } catch {
                output?.didFailToFetchRepositories(with: error)
            }
        }
    }
}
