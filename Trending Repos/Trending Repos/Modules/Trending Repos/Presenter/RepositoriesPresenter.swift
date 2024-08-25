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
    func fetchNextPage()
    var threadConstant: UInt64 { get }
}

protocol RepositoriesPresenterOutput: AnyObject {
    func showSkeletonLoader(_ bool: Bool)
    func displayRepositories(_ repositories: [Repository])
    func displayError(_ message: String)
}

class RepositoriesPresenter: RepositoriesPresenterInput {
    
    struct Constants {
        var threadConstant: UInt64 = 2_000_000_000
        static let maxAPICalls = 3
        static let timeWindow: TimeInterval = 30
    }
    
    weak var view: RepositoriesPresenterOutput?
    private let interactor: RepositoriesInteractorInput
    private let router: RepositoriesRouterInput
    private var currentPage = 1
    private var isFetchingMoreData = false
    private var hasMorePages = true
    
    private var apiCallTimestamps: [Date] = []
    
    var threadConstant: UInt64
    
    init(interactor: RepositoriesInteractorInput, router: RepositoriesRouterInput, threadConstant: UInt64 = Constants().threadConstant) {
        self.interactor = interactor
        self.router = router
        self.threadConstant = threadConstant
    }
    
    func viewDidLoad() {
        view?.showSkeletonLoader(true)
        fetchRepositories()
    }
    
    func didTapRetry() {
        view?.showSkeletonLoader(true)
        fetchRepositories()
    }
    
    func fetchNextPage() {
        guard !isFetchingMoreData, hasMorePages, canMakeAPICall() else { return }
        recordAPICall()
        isFetchingMoreData = true
        currentPage += 1
        interactor.fetchRepositories(query: "language:swift", page: currentPage)
    }
    
    private func fetchRepositories() {
        guard canMakeAPICall() else { view?.displayError(""); return }
        recordAPICall()
        isFetchingMoreData = true
        interactor.fetchRepositories(query: "language:swift", page: currentPage)
    }
    
    private func canMakeAPICall() -> Bool {
        // Remove timestamps outside of the 30-second window
        let now = Date()
        apiCallTimestamps = apiCallTimestamps.filter { now.timeIntervalSince($0) < Constants.timeWindow }
        print(apiCallTimestamps)
        // Check if the number of calls in the last 30 seconds is within the limit
        return apiCallTimestamps.count < Constants.maxAPICalls
    }
    
    private func recordAPICall() {
        apiCallTimestamps.append(Date())
    }
}

extension RepositoriesPresenter: RepositoriesInteractorOutput {
    func didFetchRepositories(_ repositories: [Repository], hasMore: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.view?.showSkeletonLoader(false)
            self.view?.displayRepositories(repositories)
        }
        isFetchingMoreData = false
        hasMorePages = hasMore
    }
    
    func didFailToFetchRepositories(with error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.view?.showSkeletonLoader(false)
            self.view?.displayError(error.localizedDescription)
        }
        isFetchingMoreData = false
    }
}
