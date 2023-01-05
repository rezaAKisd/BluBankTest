//
//  CountrieTableViewCell.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import UIKit

class CountrieTableViewCell: UITableViewCell {
    public var disposBag = Set<AnyCancellable>()
    static let height = CGFloat(130)

    private var shimmerLayer: CALayer?
    private var viewModel: CountrieItemViewModel!
    private var posterImagesRepository: ImageRepositoryInterface?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var countrieImageView: UIImageView!
    
    
    
    func fill(with viewModel: CountrieItemViewModel, imageRepository: ImageRepositoryInterface?) {
        self.viewModel = viewModel
        self.posterImagesRepository = imageRepository

        nameLabel.text = viewModel.name
        capitalLabel.text = viewModel.capital
        continentLabel.text = viewModel.continent
        timezoneLabel.text = viewModel.timezones
        updateImage()
    }

    private func updateImage() {
        countrieImageView.image = nil
        guard let imageURL = viewModel.imageURL else { return }

        posterImagesRepository?.fetchImage(with: imageURL)
            .sink(receiveCompletion: ({ _ in }), receiveValue: { [weak self] data in
                guard let self, self.viewModel.imageURL == imageURL else { return }
                if case let data = data {
                    self.countrieImageView.image = UIImage(data: data)
                }
            }).store(in: &disposBag)
    }

    func showLoading() {
        let light = UIColor(white: 0, alpha: 0.1).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, light, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]

        gradient.frame = CGRect(x: -contentView.bounds.width, y: 0, width: contentView.bounds.width * 3, height: contentView.bounds.height)

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
        countrieImageView.image = nil
        shimmerLayer?.removeFromSuperlayer()
    }
}
