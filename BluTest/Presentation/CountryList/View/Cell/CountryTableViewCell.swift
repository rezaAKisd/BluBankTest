//
//  CountryTableViewCell.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import UIKit

class CountryTableViewCell: UITableViewCell {
    public var disposBag = Set<AnyCancellable>()
    static let height = CGFloat(130)

    private var shimmerLayer: CALayer?
    private var viewModel: CountryItemViewModel!
    private var posterImagesRepository: ImageRepositoryInterface?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var continentLabel: UILabel!
    @IBOutlet var timezoneLabel: UILabel!
    @IBOutlet var countryImageView: UIImageView!

    func fill(with viewModel: CountryItemViewModel, imageRepository: ImageRepositoryInterface?) {
        self.viewModel = viewModel
        self.posterImagesRepository = imageRepository

        nameLabel.text = viewModel.name
        capitalLabel.text = viewModel.capital
        continentLabel.text = viewModel.continent
        timezoneLabel.text = viewModel.timezones
        updateImage()
        
        accessoryType = viewModel.isSelected == true ? .checkmark : .none
    }

    private func updateImage() {
        countryImageView.image = nil
        guard let imageURL = viewModel.imageURL else { return }

        posterImagesRepository?.fetchImage(with: imageURL)
            .sink(receiveCompletion: ({ _ in }), receiveValue: { [weak self] data in
                guard let self, self.viewModel.imageURL == imageURL else { return }
                if case let data = data {
                    self.countryImageView.image = UIImage(data: data)
                }
            }).store(in: &disposBag)
    }

    func showLoading() {
        let left = UIColor(white: 0.25, alpha: 0.1).cgColor
        let center = UIColor(white: 0.55, alpha: 0.3).cgColor
        let right = UIColor(white: 0.85, alpha: 0.5).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [left, center, right]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]

        gradient.frame = CGRect(x: -contentView.bounds.width,
                                y: 0, width: contentView.bounds.width * 3,
                                height: contentView.bounds.height)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]

        animation.repeatCount = .infinity
        animation.duration = 1.1
        animation.isRemovedOnCompletion = false

        gradient.add(animation, forKey: "shimmer")

        contentView.layer.addSublayer(gradient)

        shimmerLayer = gradient
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = nil
        capitalLabel.text = nil
        continentLabel.text = nil
        timezoneLabel.text = nil
        countryImageView.image = nil
        shimmerLayer?.removeFromSuperlayer()
    }
}
