//
//  CountryListViewModel.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine
import Foundation

enum CountryListViewModelStates: Equatable {
    case none
    case empty
    case loading
    case error(String)
    case countryList(CountryList)
}

protocol CountryListInput {
    func viewDidLoad()
    func searchCountry(for query: String)
    func backToHome(with selected: CountryList)
}

protocol CountryListOutput {
    var state: CurrentValueSubject<CountryListViewModelStates, Never> { get }
    var countryListDatasource: CountryListDatasource? { get set }
    var countryList: CountryList { get set }
    var itemCount: Int { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var searchBarPlaceholder: String { get }

    func applyDataSource(viewState: CountryListViewModelStates)
}

protocol CountryListViewModelInterface: CountryListInput, CountryListOutput {}

class CountryListViewModel: CountryListViewModelInterface {
    private var disposBag = Set<AnyCancellable>()
    private let countryListUseCase: CountryListUseCaseInterface
    private weak var coordinator: CountryListFlows?
    private var currentQuery: String = ""

    // MARK: - OUTPUT

    var state = CurrentValueSubject<CountryListViewModelStates, Never>(.loading)
    var countryListDatasource: CountryListDatasource?
    var countryList: CountryList = []
    var itemCount: Int { return countryListDatasource?.snapshot().numberOfItems ?? 0 }
    var isEmpty: Bool { return countryListDatasource?.snapshot().numberOfItems ?? 0 < 1 }
    var screenTitle: String = NSLocalizedString("Country List", comment: "")
    var searchBarPlaceholder: String = NSLocalizedString("Search PlaceHolder", comment: "")

    // MARK: - Init

    init(countryListUseCase: CountryListUseCaseInterface, coordinator: CountryListFlows) {
        self.countryListUseCase = countryListUseCase
        self.coordinator = coordinator
    }

    func applyDataSource(viewState: CountryListViewModelStates) {}

    deinit {
        coordinator?.backToHome()
    }

    // MARK: - Private

    private func createSnapshot(_ viewState: CountryListViewModelStates) -> CountryListSnapshot {
        var snapshot: CountryListSnapshot!
        if countryListDatasource?.snapshot().numberOfSections == 0 {
            snapshot = CountryListSnapshot()
            snapshot.appendSections([.countryList])
        } else {
            snapshot = countryListDatasource?.snapshot()
        }

        switch viewState {
        case .countryList(let countries):
            countryList.append(contentsOf: countries)
            if countries.isEmpty {
                clearSnapshot(&snapshot)
                snapshot.appendItems(CountryListItem.emptyList, toSection: .countryList)
            } else {
                let currentItems = snapshot.itemIdentifiers(inSection: .countryList)
                if currentItems.contains(where: { $0.isLoading || $0.isEmpty }) {
                    snapshot.deleteItems(currentItems)
                }
                snapshot.appendItems(countries.map(CountryListItem.country), toSection: .countryList)
            }
        case .loading:
            clearSnapshot(&snapshot)
            snapshot.appendItems(CountryListItem.loadingItems, toSection: .countryList)
        case .empty:
            clearSnapshot(&snapshot)
            snapshot.appendItems(CountryListItem.emptyList, toSection: .countryList)
        default:
            break
        }

        return snapshot
    }

    private func clearSnapshot(_ snapshot: inout CountryListSnapshot) {
        snapshot.deleteSections([.countryList])
        snapshot.appendSections([.countryList])
    }

    private func loadCountryList() {
        self.state.value = .loading

        countryListUseCase.execute()
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .finished:
                    self.state.value = .none
                case .failure(let error):
                    self.state.value = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] countryList in
                guard let self = self else { return }
                self.state.value = .countryList(countryList)

            }.store(in: &disposBag)
    }

    private func resetPages() {
        countryList.removeAll()
        state.value = .loading
    }
}

// MARK: - INPUT. View event methods

extension CountryListViewModel {
    func viewDidLoad() {
        loadCountryList()
    }

    func searchCountry(for query: String) {}

    func backToHome(with selected: CountryList) {}
}
