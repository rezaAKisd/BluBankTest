//
//  Country.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

struct Country: Equatable, Identifiable, Hashable {
    let id: String
    let name: String?
    let capital: String?
    let region: String?
    let timezones: String?
    let continent: String?
    let imageURL: String?
}

typealias CountryList = [Country]
