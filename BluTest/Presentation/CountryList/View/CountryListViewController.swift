//
//  CountryListViewController.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine
import UIKit

class CountryListViewController: UIViewController, Alertable {
    lazy var tableView: UITableView = { [unowned self] in UITableView() }()
    lazy var searchBar: UISearchBar = { [unowned self] in UISearchBar() }()
    
    public var disposBag = Set<AnyCancellable>()
    private var viewModel: CountryListViewModelInterface
    private var imageRepository: ImageRepositoryInterface?
    
    init(viewModel: CountryListViewModelInterface, imagesRepository: ImageRepositoryInterface?) {
        self.viewModel = viewModel
        self.imageRepository = imagesRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setUpBindings()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Private
    
    private func setupViews() {
        setupNavigarionView()
        
        setUpTableView()
        addSubviews()
        setUpConstraints()
    }
    
    private func setupNavigarionView() {
        title = viewModel.screenTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = viewModel.searchBarPlaceholder
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.rightButtonTitle,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(backToHome))
    }
    
    @objc func backToHome() {
        viewModel.backToHome()
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: "CountryTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: CountryTableViewCell.reuseId)
        tableView.register(HostingTableViewCell<EmptyView>.self,
                           forCellReuseIdentifier: HostingTableViewCell<EmptyView>.reuseId)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    private func addSubviews() {
        let subviews = [tableView]
        
        subviews.forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setUpBindings() {
        func bindViewToViewModel() {
            searchBar.searchTextField.textPublisher
                .debounce(for: 0.3, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] searchText in
                    self?.viewModel.searchCountry(for: searchText)
                }
                .store(in: &disposBag)
        }
        
        func bindViewModelToView() {
            viewModel.state
                .sink(receiveValue: { [weak self] in self?.updateViewState($0) }).store(in: &disposBag)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }

    private func updateViewState(_ state: CountryListViewModelStates) {
        switch state {
        case .loading, .empty, .countryList, .searchList:
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .error(let errorMessage):
            showError(errorMessage)
            viewModel.state.value = .none
        default:
            break
        }
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: error, message: error)
    }
}

// MARK: - TableViewDataSource

extension CountryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let state = viewModel.state.value
        switch state {
        case .empty:
            return state.emptyList.count
        case .loading:
            return state.loadingItems.count
        case .countryList, .searchList:
            return viewModel.countryListDataSource.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let state = viewModel.state.value
        switch state {
        case .empty:
            let cell: HostingTableViewCell<EmptyView> = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.host(EmptyView(emptyTitle: viewModel.emptySearchTitle), parent: self)
            return cell
        case .loading:
            let cell: CountryTableViewCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.showLoading()
            return cell
        case .countryList, .searchList:
            let cell: CountryTableViewCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.fill(with: .init(country: viewModel.countryListDataSource[indexPath.row]),
                      imageRepository: imageRepository)
            return cell
        default: return UITableViewCell()
        }
    }
}

// MARK: - TableViewDelegate

extension CountryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath)
        updateCellSelection(indexPath)
    }
    
    func updateCellSelection(_ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CountryTableViewCell else { return }
        cell.accessoryType = viewModel.countryListDataSource[indexPath.row].isSelected == true ? .checkmark : .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let state = viewModel.state.value
        switch state {
        case .empty, .loading:
            return tableView.frame.height
        case .countryList, .searchList:
            return tableView.estimatedRowHeight
        default: return 0.0
        }
    }
}
