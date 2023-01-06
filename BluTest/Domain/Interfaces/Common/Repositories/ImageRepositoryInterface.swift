//
//  ImageRepository.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import Foundation

protocol ImageRepositoryInterface {
    @discardableResult
    func fetchImage(with imagePath: String) -> AnyPublisher<Data, Error>
}
