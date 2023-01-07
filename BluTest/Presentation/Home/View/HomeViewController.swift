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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Country List", comment: ""),
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
            viewModel.homeDatasource = HomeDatasource(tableView: tableView) { tableView, indexPath, styleItem -> UITableViewCell? in
                self.cell(collectionView: tableView, indexPath: indexPath, homeItem: styleItem)
            }
            
            viewModel.state
                .sink(receiveValue: { [weak self] in self?.updateViewState($0) }).store(in: &disposBag)
        }
        
        bindViewModelToView()
        viewModel.applyDataSource(viewState: .empty)
    }
    
    private func cell(collectionView: UITableView, indexPath: IndexPath, homeItem: HomeItem) -> UITableViewCell {
        switch homeItem {
        case .empty:
            let cell: HostingTableViewCell<EmptyView> = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.host(EmptyView(emptyTitle: viewModel.emptyListTitle), parent: self)
            return cell
        case .country(let country):
            let cell: CountryTableViewCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.fill(with: .init(country: country),
                      imageRepository: imageRepository)
            
            return cell
        }
    }

    private func updateViewState(_ state: HomeViewModelStates) {
        switch state {
        case .selectedCountryList(let countries):
            viewModel.applyDataSource(viewState: .selectedCountryList(countries))
            viewModel.state.value = .none
        default:
            break
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = viewModel.homeDatasource?.itemIdentifier(for: indexPath)
        switch cell {
        case .empty:
            return tableView.frame.height
        default:
            return tableView.estimatedRowHeight
        }
    }
}
