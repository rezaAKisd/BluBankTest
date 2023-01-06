//
//  CountryListRepositoryInterface.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine
import Foundation

protocol CountryListRepositoryInterface {
    @discardableResult
    func fetchCountryList() -> AnyPublisher<CountryList, Error>
}
