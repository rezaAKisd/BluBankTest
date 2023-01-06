//
//  CountryListResponseDTO+Mapping.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Foundation

typealias CountryListResponseDTO = [CountryResponseDTO]

struct CountryResponseDTO: Codable {
    let name: Name?
    let capital: [String]?
    let region: String?
    let timezones, continents: [String]?
    let flags: Flags?
}

// MARK: - Flags

extension CountryResponseDTO {
    struct Flags: Codable {
        let png: String?
    }
}

// MARK: - Name

extension CountryResponseDTO {
    struct Name: Codable {
        let common, official: String?
    }
}

// MARK: - Mappings to Domain

extension CountryResponseDTO {
    func toDomain() -> Country {
        return .init(id: UUID().uuidString,
                     name: name?.common,
                     capital: capital?.first,
                     region: region,
                     timezones: timezones?.first,
                     continent: continents?.first,
                     imageURL: flags?.png)
    }
}
