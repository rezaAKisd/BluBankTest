//
//  AppCoordinator.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let apiService = appDIContainer.apiDataTransferService
        let imgService = appDIContainer.imageDataTransferService
        let moviesSceneDI = HomeDIContainer(dependencies: .init(apiDataTransferService: apiService,
                                                                imageDataTransferService: imgService))

        let homeCoordinator = HomeFlowCoordinator(navigationController: navigationController,
                                                  dependencies: moviesSceneDI)

        coordinate(to: homeCoordinator)
        childCoordinators.append(homeCoordinator)
    }
}
