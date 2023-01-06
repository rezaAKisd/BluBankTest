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
        let homeSceneDI = HomeDIContainer(dependencies: .init(apiDataTransferService: apiService,
                                                              imageDataTransferService: imgService))

        let homeCoordinator = HomeFlowCoordinator(navigationController: navigationController,
                                                  appDIContainer: appDIContainer,
                                                  dependencies: homeSceneDI)

        childCoordinators.append(homeCoordinator)
        coordinate(to: homeCoordinator)
    }
}
