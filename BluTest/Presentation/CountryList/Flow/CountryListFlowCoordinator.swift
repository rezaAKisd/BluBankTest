//
//  CountryListFlowCoordinator.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine
import UIKit

protocol BackToHomeFlowCoordinate: AnyObject {
    func navigateBackToHome(coordinator: Coordinator, countryList: CountryList)
}

protocol CountryListFlows: AnyObject {
    func backToHome(with countries: CountryList)
}

final class CountryListFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var backDelegate: BackToHomeFlowCoordinate?
    
    private let appDIContainer: AppDIContainer
    private let dependencies: CountryListDependencies
    private let selectedCountries: CountryList

    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer,
         dependencies: CountryListDependencies,
         selectedCountryList: CountryList) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.dependencies = dependencies
        self.selectedCountries = selectedCountryList
    }

    func start() {
        let viewModel = dependencies.countryListViewModel(coordinator: self, selectedCountries: selectedCountries)
        let countryListVC = CountryListViewController(viewModel: viewModel,
                                                      imagesRepository: dependencies.imagesRepository())
        
        navigationController.pushViewController(countryListVC, animated: true)
    }
}

extension CountryListFlowCoordinator: CountryListFlows {
    func backToHome(with countries: CountryList) {
        backDelegate?.navigateBackToHome(coordinator: self, countryList: countries)
    }
}
