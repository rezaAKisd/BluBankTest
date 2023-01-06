//
//  CountryListDIContainer.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import UIKit

protocol CountryListDependencies {
    func countryListViewModel(coordinator: CountryListFlows) -> CountryListViewModelInterface
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

    // MARK: - Repository

    func imagesRepository() -> ImageRepositoryInterface {
        return ImageRepository(dataTransferService: dependencies.apiDataTransferService)
    }

    // MARK: - Home

    func countryListViewModel(coordinator: CountryListFlows) -> CountryListViewModelInterface {
        return CountryListViewModel(coordinator: coordinator)
    }
}
