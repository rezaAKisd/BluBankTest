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
        navigationController.navigationBar.isHidden = true

        let vc = ViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
