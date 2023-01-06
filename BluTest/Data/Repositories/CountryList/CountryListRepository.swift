//
//  CountryListRepository.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine
import Foundation

final class CountryListRepository {
    private var disposBag = Set<AnyCancellable>()
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension CountryListRepository: CountryListRepositoryInterface {
    func fetchCountryList() -> AnyPublisher<CountryList, Error> {
        let endpoint = CountryEndPoints.getCountryList

        return self.dataTransferService.request(endpoint,
                                                decodeModel: CountryListResponseDTO.self)
            .map { responseDTO -> CountryList in

                (responseDTO.map { $0.toDomain() })
            }.eraseToAnyPublisher()
    }
}
