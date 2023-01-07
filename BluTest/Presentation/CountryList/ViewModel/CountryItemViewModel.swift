//
//  CountryItemViewModel.swift
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
    let isSelected: Bool
}

extension CountryItemViewModel {
    init(country: Country) {
        self.id = country.id
        self.name = country.name ?? ""
        self.capital = country.capital ?? ""
        self.region = country.region ?? ""
        self.continent = country.continent ?? ""
        self.timezones = country.timezones ?? ""
        self.imageURL = country.imageURL
        self.isSelected = country.isSelected
    }
}
