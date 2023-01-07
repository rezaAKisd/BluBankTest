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
    case selectedCountryList
}

protocol HomeViewModelInput {
    func viewDidLoad()
    func showCountryList()
}

protocol HomeViewModelOutput {
    var state: CurrentValueSubject<HomeViewModelStates, Never> { get }
    var selectedCountryList: CountryList { get set }
    var itemCount: Int { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var rightButtonTitle: String { get }
    var emptyListTitle: String { get }
}

protocol HomeViewModelInterface: HomeViewModelInput, HomeViewModelOutput {}

class HomeViewModel: HomeViewModelInterface {
    private var disposBag = Set<AnyCancellable>()
    private weak var coordinator: HomeFlows?

    // MARK: - OUTPUT

    var state = CurrentValueSubject<HomeViewModelStates, Never>(.empty)
    var selectedCountryList: CountryList = []
    var itemCount: Int { return selectedCountryList.count }
    var isEmpty: Bool { return selectedCountryList.count < 1 }
    let screenTitle = NSLocalizedString("Selected Countries", comment: "")
    let rightButtonTitle: String = NSLocalizedString("Country List", comment: "")
    let emptyListTitle: String = NSLocalizedString("Any Selected Country", comment: "")

    // MARK: - Init

    init(coordinator: HomeFlows) {
        self.coordinator = coordinator
    }

    // MARK: - Private
}

// MARK: - INPUT. View event methods

extension HomeViewModel {
    func viewDidLoad() {
        state.value = .empty
    }

    func showCountryList() {
        coordinator?.showCountryList(with: selectedCountryList)
    }
}
