//
//  CountryListFlowCoordinator.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine
import UIKit

protocol CountryListFlows: AnyObject {
    func backToHome()
}

final class CountryListFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var backDelegate: CoordinateBackDelegate?
    
    private let appDIContainer: AppDIContainer
    private let dependencies: CountryListDependencies
    private let selectedCountryList: CountryList

    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer,
         dependencies: CountryListDependencies,
         selectedCountryList: CountryList) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.dependencies = dependencies
        self.selectedCountryList = selectedCountryList
    }

    func start() {
        let viewModel = dependencies.countryListViewModel(coordinator: self)
        let countryListVC = CountryListViewController(viewModel: viewModel,
                                                      imagesRepository: dependencies.imagesRepository())
        
        navigationController.pushViewController(countryListVC, animated: true)
    }
}

extension CountryListFlowCoordinator: CountryListFlows {
    func backToHome() {
        backDelegate?.navigateBackToFirstPage(coordinator: self)
    }
}
