//
//  RepositoriesBuilder.swift
//  Trending Repos
//
//  Created by MacBook Pro on 25/08/2024.
//

import Foundation
import UIKit

class RepositoriesBuilder {
    static func build() -> UIViewController {
        let networkManager = NetworkManager()
        let interactor = RepositoriesInteractor(networkManager: networkManager)
        let router = RepositoriesRouter()
        let presenter = RepositoriesPresenter(interactor: interactor, router: router)
        let viewController = RepositoriesViewController.instantiate(fromStoryBoards: .Main)
        
        interactor.output = presenter
        presenter.view = viewController
        router.viewController = viewController
        viewController.presenter = presenter
        
        return viewController
    }
}
