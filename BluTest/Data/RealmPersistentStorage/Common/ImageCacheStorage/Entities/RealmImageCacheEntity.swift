//
//  RealmImageCacheEntity.swift
//  BluTest
//
//  Created by reza akbari on 1/7/23.
//

import Foundation
import RealmSwift

class RealmImageCacheEntity: Object {
    @Persisted var primaryKey: String = UUID().uuidString
    @Persisted var image: Data
    @Persisted var path: String

    override static func primaryKey() -> String? {
        return "primaryKey"
    }

    convenience init(image: Data, path: String) {
        self.init()
        self.image = image
        self.path = path
    }
}
