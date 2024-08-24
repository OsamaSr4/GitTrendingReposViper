//
//  RepositoriesPresenter.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation

protocol RepositoriesPresenterInput {
    func viewDidLoad()
    func didTapRetry()
}

protocol RepositoriesPresenterOutput: AnyObject {
    func displayRepositories(_ repositories: [Repository])
    func displayError(_ message: String)
}

class RepositoriesPresenter: RepositoriesPresenterInput {
    weak var view: RepositoriesPresenterOutput?
    private let interactor: RepositoriesInteractorInput
    private let router: RepositoriesRouterInput
    
    init(interactor: RepositoriesInteractorInput, router: RepositoriesRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchRepositories(query: "1")
    }
    
    func didTapRetry() {
        interactor.fetchRepositories(query: "1")
    }
}

extension RepositoriesPresenter: RepositoriesInteractorOutput {
    func didFetchRepositories(_ repositories: [Repository]) {
        view?.displayRepositories(repositories)
    }
    
    func didFailToFetchRepositories(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
}
