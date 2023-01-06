//
//  HomeFlowCoordinator.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import UIKit

protocol HomeFlows: AnyObject {
    func showCountryList(with selectedCountries: [Country])
}

final class HomeFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    private let dependencies: HomeDependencies

    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer,
         dependencies: HomeDependencies) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.dependencies = dependencies
    }

    func start() {
        let homeVC = HomeViewController(viewModel: dependencies.homeViewModel(coordinator: self),
                                        imagesRepository: dependencies.imagesRepository())
        navigationController.pushViewController(homeVC, animated: false)
    }
}

extension HomeFlowCoordinator: HomeFlows {
    func showCountryList(with selectedCountries: CountryList) {
        let countryListCoordinator = makeCountryListCoordinator(with: selectedCountries)

        childCoordinators.append(countryListCoordinator)
        coordinate(to: countryListCoordinator)
    }

    private func makeCountryListCoordinator(with selectedCountries: CountryList) -> CountryListFlowCoordinator {
        let apiService = appDIContainer.apiDataTransferService
        let imgService = appDIContainer.imageDataTransferService
        let countryListSceneDI = CountryListDIContainer(dependencies: .init(apiDataTransferService: apiService,
                                                                            imageDataTransferService: imgService))

        let countryListCoordinator = CountryListFlowCoordinator(navigationController: navigationController,
                                                                appDIContainer: appDIContainer,
                                                                dependencies: countryListSceneDI,
                                                                selectedCountryList: selectedCountries)
        countryListCoordinator.backDelegate = self
        return countryListCoordinator
    }
}

extension HomeFlowCoordinator: CoordinateBackDelegate {
    func navigateBackToFirstPage(coordinator: Coordinator) {
        self.removeChild(for: coordinator)
    }
}
