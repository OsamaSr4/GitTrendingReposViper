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
    var threadConstant : UInt64 {get}
}

protocol RepositoriesPresenterOutput: AnyObject {
    func showSkeletonLoader(_ bool : Bool)
    func displayRepositories(_ repositories: [Repository])
    func displayError(_ message: String)
}

class RepositoriesPresenter: RepositoriesPresenterInput {
    
    struct Constants {
        var threadConstant : UInt64 = 2_000_000_000
    }
    
    weak var view: RepositoriesPresenterOutput?
    private let interactor: RepositoriesInteractorInput
    private let router: RepositoriesRouterInput
    var threadConstant: UInt64
    
    init(interactor: RepositoriesInteractorInput, router: RepositoriesRouterInput, threadConstant: UInt64 = Constants().threadConstant) {
        self.interactor = interactor
        self.router = router
        self.threadConstant = threadConstant
    }
    
    func viewDidLoad() {
        view?.showSkeletonLoader(true)
        interactor.fetchRepositories(query: "1")
        print("viewDidLoad")
    }
    
    func didTapRetry() {
        view?.showSkeletonLoader(true)
        interactor.fetchRepositories(query: "1")
    }
}

extension RepositoriesPresenter: RepositoriesInteractorOutput {
    func didFetchRepositories(_ repositories: [Repository]) {
        view?.showSkeletonLoader(false)
        view?.displayRepositories(repositories)
    }
    
    func didFailToFetchRepositories(with error: Error) {
        view?.showSkeletonLoader(false)
        view?.displayError(error.localizedDescription)
    }
}
