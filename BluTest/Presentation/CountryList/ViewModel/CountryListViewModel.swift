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
    case countryList
    case searchList

    var emptyList: [CountryListViewModelStates] {
        return Array(repeatingExpression: CountryListViewModelStates.empty, count: 1)
    }

    var loadingItems: [CountryListViewModelStates] {
        return Array(repeatingExpression: CountryListViewModelStates.loading, count: 12)
    }
}

protocol CountryListInput {
    func viewDidLoad()
    func selectItem(at indexPath: IndexPath)
    func searchCountry(for query: String)
    func backToHome()
}

protocol CountryListOutput {
    var state: CurrentValueSubject<CountryListViewModelStates, Never> { get }
    var countryListDataSource: CountryList { get set }
    var itemCount: Int { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var rightButtonTitle: String { get }
    var searchBarPlaceholder: String { get }
    var emptySearchTitle: String { get }
}

protocol CountryListViewModelInterface: CountryListInput, CountryListOutput {}

class CountryListViewModel: CountryListViewModelInterface {
    private var disposBag = Set<AnyCancellable>()
    private let countryListUseCase: CountryListUseCaseInterface
    private weak var coordinator: CountryListFlows?
    private var countryList: CountryList = []
    private var searchQuery: String?

    // MARK: - OUTPUT

    var state = CurrentValueSubject<CountryListViewModelStates, Never>(.loading)
    var countryListDataSource: CountryList = []
    var itemCount: Int { return countryListDataSource.count }
    var isEmpty: Bool { return countryListDataSource.count < 1 }
    var screenTitle: String = NSLocalizedString("Country List", comment: "")
    var rightButtonTitle: String = NSLocalizedString("Done", comment: "")
    var searchBarPlaceholder: String = NSLocalizedString("Search PlaceHolder", comment: "")
    var emptySearchTitle: String {
        return String.localizedStringWithFormat(NSLocalizedString("Empty Search Result", comment: ""), searchQuery ?? "")
    }

    // MARK: - Init

    init(countryListUseCase: CountryListUseCaseInterface, coordinator: CountryListFlows) {
        self.countryListUseCase = countryListUseCase
        self.coordinator = coordinator
    }

    // MARK: - Private

    private func loadCountryList() {
        resetPages()

        countryListUseCase.execute()
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .finished:
                    break
                case .failure(let error):
                    self.state.value = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] countryList in
                guard let self else { return }
                self.countryList.removeAll()
                self.countryList.append(contentsOf: countryList)
                self.countryListDataSource = self.countryList
                self.state.value = .countryList

            }.store(in: &disposBag)
    }

    private func resetPages() {
        countryListDataSource.removeAll()
        state.value = .loading
    }
}

// MARK: - INPUT. View event methods

extension CountryListViewModel {
    func viewDidLoad() {
        loadCountryList()
    }

    func selectItem(at indexPath: IndexPath) {
        countryListDataSource[indexPath.row].isSelected.toggle()
        switch state.value {
        case .countryList:
            countryList[indexPath.row].isSelected.toggle()
        case .searchList:
            let selectedItem = countryListDataSource[indexPath.row]
            if let index = countryList.firstIndex(where: { $0.id == selectedItem.id }) {
                countryList[index].isSelected.toggle()
            }
        default: break
        }
    }

    func searchCountry(for query: String) {
        searchQuery = query
        guard query != "" else {
            countryListDataSource = countryList
            state.value = .countryList
            return
        }
        let searchResult = countryList.filter {
            ($0.name ?? "").localizedCaseInsensitiveContains(query) ||
                ($0.capital ?? "").localizedCaseInsensitiveContains(query) ||
                ($0.region ?? "").localizedCaseInsensitiveContains(query)
        }
        if searchResult.isEmpty {
            state.value = .empty
        } else {
            countryListDataSource = searchResult
            state.value = .searchList
        }
    }

    func backToHome() {
        coordinator?.backToHome(with: countryList.filter { $0.isSelected == true })
    }
}
