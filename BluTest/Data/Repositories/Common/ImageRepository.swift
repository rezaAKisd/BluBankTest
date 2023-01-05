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

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension ImageRepository: ImageRepositoryInterface {
    func fetchImage(with imagePath: String) -> AnyPublisher<Data, Error> {
        let endpoint = ImageEndPoints.getMoviePoster(path: imagePath)
        return self.dataTransferService.request(endpoint)
    }
}
