//
//  ImageCacheStorageInterface.swift
//  BluTest
//
//  Created by reza akbari on 1/7/23.
//

import Combine
import Foundation

protocol ImageCacheStorageInterface {
    func getImage(for path: String) -> AnyPublisher<Data?, Error>
    func save(image: Data, for path: String)
}
