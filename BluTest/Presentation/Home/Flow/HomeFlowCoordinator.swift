//
//  HomeFlowCoordinator.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import UIKit

protocol HomeFlows: AnyObject {
    func showCountryList()
}

final class HomeFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let dependencies: HomeDependencies

    init(navigationController: UINavigationController,
         dependencies: HomeDependencies)
    {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let movieListVC = HomeViewController(viewModel: dependencies.homeViewModel(coordinator: self), imagesRepository: dependencies.imagesRepository())
        navigationController.pushViewController(movieListVC, animated: false)
    }
}

extension HomeFlowCoordinator: HomeFlows {
    func showCountryList() {
        // Todo
    }
}
