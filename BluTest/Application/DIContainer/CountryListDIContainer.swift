//
//  CountryListDIContainer.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import UIKit

protocol CountryListDependencies {
    func countryListViewModel(coordinator: CountryListFlows, selectedCountries: CountryList) -> CountryListViewModelInterface
    func imagesRepository() -> ImageRepositoryInterface
}

final class CountryListDIContainer: CountryListDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }

    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases

    func makeCountryListUseCase() -> CountryListUseCaseInterface {
        return CountryListUseCase(countryListRepository: makeCountryListRepository())
    }
    
    // MARK: - Repository

    func makeCountryListRepository() -> CountryListRepositoryInterface {
        return CountryListRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func imagesRepository() -> ImageRepositoryInterface {
        return ImageRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    // MARK: - Country List

    func countryListViewModel(coordinator: CountryListFlows, selectedCountries: CountryList) -> CountryListViewModelInterface {
        return CountryListViewModel(countryListUseCase: makeCountryListUseCase(),
                                    coordinator: coordinator,
                                    selectedCountries: selectedCountries)
    }
}
