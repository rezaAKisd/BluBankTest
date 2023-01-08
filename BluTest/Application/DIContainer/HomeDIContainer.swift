//
//  HomeDIContainer.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import UIKit

protocol HomeDependencies {
    func homeViewModel(coordinator: HomeFlows) -> HomeViewModelInterface
    func imagesRepository() -> ImageRepositoryInterface
}

final class HomeDIContainer: HomeDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
        let imageCacheService: RealmCRUD
    }

    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Persistent Storage

    lazy var imageCacheStorage: ImageCacheStorageInterface = RealmImageCacheStorage(realmDB:
                                                                                        dependencies.imageCacheService)

    // MARK: - Repository

    func imagesRepository() -> ImageRepositoryInterface {
        return ImageRepository(dataTransferService: dependencies.apiDataTransferService,
                               imageCacheStorage: imageCacheStorage)
    }

    // MARK: - Home

    func homeViewModel(coordinator: HomeFlows) -> HomeViewModelInterface {
        return HomeViewModel(coordinator: coordinator)
    }
}
