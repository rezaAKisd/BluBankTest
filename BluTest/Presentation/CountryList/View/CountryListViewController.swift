//
//  CountryListViewController.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Combine
import UIKit

class CountryListViewController: UIViewController {
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
    }
}
