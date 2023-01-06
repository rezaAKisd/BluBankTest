//
//  CountryListUseCase.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine

protocol CountryListUseCaseInterface {
    func execute() -> AnyPublisher<CountryList, Error>
}

final class CountryListUseCase: CountryListUseCaseInterface {
    private let countryListRepository: CountryListRepositoryInterface

    init(countryListRepository: CountryListRepositoryInterface) {
        self.countryListRepository = countryListRepository
    }

    func execute() -> AnyPublisher<CountryList, Error> {
        return countryListRepository.fetchCountryList()
    }
}
