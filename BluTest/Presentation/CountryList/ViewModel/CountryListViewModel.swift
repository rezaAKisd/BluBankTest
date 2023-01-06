//
//  CountryListViewModel.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine
import Foundation

protocol CountryListInput {}
protocol CountryListOutput {}
protocol CountryListViewModelInterface: CountryListInput, CountryListOutput {}

class CountryListViewModel: CountryListViewModelInterface {
    private var disposBag = Set<AnyCancellable>()
    private weak var coordinator: CountryListFlows?

    init(coordinator: CountryListFlows) {
        self.coordinator = coordinator
    }

    deinit {
        coordinator?.backToHome()
    }
}
