//
//  HomeViewController.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import UIKit

class HomeViewController: UIViewController {
    lazy var tableView: UITableView = { [unowned self] in UITableView() }()
    
    public var disposBag = Set<AnyCancellable>()
    private var viewModel: HomeViewModelInterface
    private var imageRepository: ImageRepositoryInterface?
    
    init(viewModel: HomeViewModelInterface, imagesRepository: ImageRepositoryInterface?) {
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.rightButtonTitle,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(goToCountryList))
    }
    
    @objc func goToCountryList() {
        viewModel.showCountryList()
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: "CountryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: CountryTableViewCell.reuseId)
        tableView.register(HostingTableViewCell<EmptyView>.self,
                           forCellReuseIdentifier: HostingTableViewCell<EmptyView>.reuseId)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
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
        func bindViewModelToView() {
            viewModel.state
                .sink(receiveValue: { [weak self] in self?.updateViewState($0) }).store(in: &disposBag)
        }
        
        bindViewModelToView()
    }
    
    private func updateViewState(_ state: HomeViewModelStates) {
        switch state {
        case .selectedCountryList, .empty:
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default:
            break
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state.value {
        case .empty:
            return 1
        case .selectedCountryList:
            return viewModel.itemCount
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state.value {
        case .empty:
            let cell: HostingTableViewCell<EmptyView> = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.host(EmptyView(emptyTitle: viewModel.emptyListTitle), parent: self)
            return cell
        case .selectedCountryList:
            let cell: CountryTableViewCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.fill(with: .init(country: viewModel.selectedCountryList[indexPath.row]),
                      imageRepository: imageRepository)
            
            return cell
        default: return UITableViewCell()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.state.value {
        case .selectedCountryList:
            return tableView.estimatedRowHeight
        case .empty:
            return tableView.frame.height
        default:
            return 0.0
        }
    }
}
