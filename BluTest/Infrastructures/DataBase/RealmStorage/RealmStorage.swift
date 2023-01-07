//
//  RealmStorage.swift
//  BluTest
//
//  Created by reza akbari on 1/7/23.
//

import Combine
import Foundation
import RealmSwift

enum RealmStorageError: Error {
    case `default`
    case readError(Error)
    case writeError(Error)
    case deleteError(Error)
}

protocol RealmCRUD {
    @discardableResult
    func write(_ objc: Object) -> AnyPublisher<Bool, Error>
    @discardableResult
    func delete(obj: ObjectBase) -> AnyPublisher<Bool, Error>
    @discardableResult
    func deleteAll<T>(obj: List<T>) -> AnyPublisher<Bool, Error> where T: Object
    @discardableResult
    func fetchAll<T>(model: T.Type) -> AnyPublisher<[T], Error> where T: Object
}

class RealmStorage {
    var realmDB: Realm?

    init(config: Realm.Configuration) {
        try? realmDB = Realm(configuration: config)
    }

    func write(_ objc: Object) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promis in
            guard let self else { return promis(.failure(RealmStorageError.default)) }
            do {
                try self.realmDB?.write {
                    self.realmDB?.add(objc)
                }
                promis(.success(true))
            } catch {
                promis(.failure(RealmStorageError.writeError(error)))
            }
        }.eraseToAnyPublisher()
    }

    func delete(obj: ObjectBase) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promis in
            guard let self else { return promis(.failure(RealmStorageError.default)) }
            do {
                try self.realmDB?.write {
                    self.realmDB?.delete(obj)
                }
                promis(.success(true))
            } catch {
                promis(.failure(RealmStorageError.deleteError(error)))
            }
        }.eraseToAnyPublisher()
    }

    func deleteAll<T>(obj: List<T>) -> AnyPublisher<Bool, Error> where T: Object {
        return Future<Bool, Error> { [weak self] promis in
            guard let self else { return promis(.failure(RealmStorageError.default)) }
            do {
                try self.realmDB?.write {
                    self.realmDB?.delete(obj)
                }
                promis(.success(true))
            } catch {
                promis(.failure(RealmStorageError.deleteError(error)))
            }
        }.eraseToAnyPublisher()
    }

    func fetchAll<T: Object>(model: T.Type) -> AnyPublisher<[T], Error> {
        return Future<[T], Error> { [weak self] promis in
            guard let self, let realmDB = self.realmDB else { return promis(.failure(RealmStorageError.default)) }
            promis(.success(Array(realmDB.objects(model.self))))
        }.eraseToAnyPublisher()
    }
}

extension RealmStorage: RealmCRUD {}
