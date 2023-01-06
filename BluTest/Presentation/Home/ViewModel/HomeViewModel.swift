//
//  HomeViewModel.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import Foundation

enum HomeViewModelStates: Equatable {
    case none
    case empty
    case selectedCountryList(CountryList)
}

protocol HomeViewModelInput {
    func viewDidLoad()
    func showCountryList()
}

protocol HomeViewModelOutput {
    var state: CurrentValueSubject<HomeViewModelStates, Never> { get }
    var homeDatasource: HomeDatasource? { get set }
    var selectedCountryList: [Country] { get set }
    var itemCount: Int { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }

    func applyDataSource(viewState: HomeViewModelStates)
}

protocol HomeViewModelInterface: HomeViewModelInput, HomeViewModelOutput {}

class HomeViewModel: HomeViewModelInterface {
    private var disposBag = Set<AnyCancellable>()
    private weak var coordinator: HomeFlows?

    // MARK: - OUTPUT

    var state = CurrentValueSubject<HomeViewModelStates, Never>(.empty)
    var homeDatasource: HomeDatasource?
    var selectedCountryList: [Country] = []
    var itemCount: Int { return homeDatasource?.snapshot().numberOfItems ?? 0 }
    var isEmpty: Bool { return homeDatasource?.snapshot().numberOfItems ?? 0 < 1 }
    let screenTitle = NSLocalizedString("Selected Countries", comment: "")

    // MARK: - Init

    init(coordinator: HomeFlows) {
        self.coordinator = coordinator
    }

    func applyDataSource(viewState: HomeViewModelStates) {
        DispatchQueue.main.async { [self] in
            homeDatasource?.apply(createSnapshot(viewState), animatingDifferences: false)
        }
    }

    // MARK: - Private

    private func createSnapshot(_ viewState: HomeViewModelStates) -> HomeSnapshot {
        var snapshot: HomeSnapshot!
        if homeDatasource?.snapshot().numberOfSections == 0 {
            snapshot = HomeSnapshot()
            snapshot.appendSections([.selectedCountries])
        } else {
            snapshot = homeDatasource?.snapshot()
        }

        switch viewState {
        case .selectedCountryList(let countries):
            selectedCountryList.append(contentsOf: countries)
            
            if countries.isEmpty {
                clearSnapshot(&snapshot)
                snapshot.appendItems(HomeItem.emptyList, toSection: .selectedCountries)
            } else {
                let currentItems = snapshot.itemIdentifiers(inSection: .selectedCountries)
                if currentItems.contains(where: { $0.isEmpty }) {
                    snapshot.deleteItems(currentItems)
                }
                snapshot.appendItems(countries.map(HomeItem.country), toSection: .selectedCountries)
            }
        case .empty:
            clearSnapshot(&snapshot)
            snapshot.appendItems(HomeItem.emptyList, toSection: .selectedCountries)
        default:
            break
        }

        return snapshot
    }

    private func clearSnapshot(_ snapshot: inout HomeSnapshot) {
        snapshot.deleteSections([.selectedCountries])
        snapshot.appendSections([.selectedCountries])
    }
}

// MARK: - INPUT. View event methods

extension HomeViewModel {
    func viewDidLoad() {}

    func showCountryList() {
        coordinator?.showCountryList(with: [])
    }
}
