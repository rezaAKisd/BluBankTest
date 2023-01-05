//
//  CountrieItemViewModel.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

struct CountryItemViewModel: Equatable, Hashable {
    let id: String
    let name: String?
    let capital: String?
    let region: String?
    let timezones: String?
    let continent: String?
    let imageURL: String?
}

extension CountryItemViewModel {
    init(countrie: Country) {
        self.id = countrie.id
        self.name = countrie.name ?? ""
        self.capital = countrie.capital ?? ""
        self.region = countrie.region ?? ""
        self.continent = countrie.continent ?? ""
        self.timezones = countrie.timezones ?? ""
        self.imageURL = countrie.imageURL
    }
}

