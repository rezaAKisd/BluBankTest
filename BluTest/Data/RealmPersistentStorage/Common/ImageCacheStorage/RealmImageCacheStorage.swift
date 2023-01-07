//
//  RealmImageCacheStorage.swift
//  BluTest
//
//  Created by reza akbari on 1/7/23.
//

import Combine
import Foundation
import RealmSwift

final class RealmImageCacheStorage {
    private let realmDB: RealmCRUD

    init(realmDB: RealmCRUD) {
        self.realmDB = realmDB
    }

    func getImage(for path: String) -> AnyPublisher<Data?, Error> {
        return self.realmDB.fetchAll(model: RealmImageCacheEntity.self)
            .map({ $0.first(where: {$0.path == path}) })
            .map(\.?.image)
            .eraseToAnyPublisher()
    }

    func save(image: Data, for path: String) {
        self.realmDB.write(RealmImageCacheEntity(image: image, path: path))
    }
}

extension RealmImageCacheStorage: ImageCacheStorageInterface {}
