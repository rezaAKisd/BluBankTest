//
//  ImageRepository2.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import Foundation

final class ImageRepository {
    private let dataTransferService: DataTransferService
    private let imageCacheStorage: ImageCacheStorageInterface

    init(dataTransferService: DataTransferService,
         imageCacheStorage: ImageCacheStorageInterface)
    {
        self.dataTransferService = dataTransferService
        self.imageCacheStorage = imageCacheStorage
    }
}

extension ImageRepository: ImageRepositoryInterface {
    func fetchImage(with imagePath: String) -> AnyPublisher<Data, Error> {
        let endpoint = ImageEndPoints.getMoviePoster(path: imagePath)

        return self.imageCacheStorage.getImage(for: imagePath)
            .flatMap { data -> AnyPublisher<Data, Error> in
                if let data {
                    return Future<Data, Error> { promis in
                        promis(.success(data))
                    }.eraseToAnyPublisher()
                } else {
                    return self.dataTransferService.request(endpoint).map { data in
                        self.imageCacheStorage.save(image: data, for: imagePath)
                        return data
                    }.eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
