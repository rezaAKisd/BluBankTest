//
//  CountryListDataSource.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import UIKit

typealias CountryListSnapshot = NSDiffableDataSourceSnapshot<CountryListSection, CountryListItem>
typealias CountryListDatasource = UITableViewDiffableDataSource<CountryListSection, CountryListItem>

enum CountryListSection: Hashable {
    case countryList
}

enum CountryListItem: Hashable {
    case empty(UUID)
    case loading(UUID)
    case country(Country)

    var isEmpty: Bool {
        switch self {
        case .empty:
            return true
        default:
            return false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }

    static var emptyList: [CountryListItem] {
        return Array(repeatingExpression: CountryListItem.empty(UUID()), count: 1)
    }
    
    static var loadingItems: [CountryListItem] {
        return Array(repeatingExpression: CountryListItem.loading(UUID()), count: 12)
    }
}
