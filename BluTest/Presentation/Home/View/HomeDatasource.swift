//
//  HomeListDataSource.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import UIKit

typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>
typealias HomeDatasource = UITableViewDiffableDataSource<HomeSection, HomeItem>

enum HomeSection: Hashable {
    case selectedCountries
}

enum HomeItem: Hashable {
    case empty(UUID)
    case countries(Countrie)

    var isEmpty: Bool {
        switch self {
        case .empty:
            return true
        default:
            return false
        }
    }

    static var emptyList: [HomeItem] {
        return Array(repeatingExpression: HomeItem.empty(UUID()), count: 1)
    }
}
