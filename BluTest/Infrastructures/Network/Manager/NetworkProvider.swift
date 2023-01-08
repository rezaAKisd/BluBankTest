//
//  NetworkProvider.swift
//  BluTest
//
//  Created by reza akbari on 1/8/23.
//

import Combine
import Foundation

protocol DataTransferService {
    @discardableResult
    func request<T: EndPointType, W: Decodable>(_ target: T, decodeModel: W.Type) -> AnyPublisher<W, Error>

    @discardableResult
    func request<T: EndPointType>(_ target: T) -> AnyPublisher<Data, Error>
}

final class NetworkProvider: DataTransferService {
    private let router: Router

    init(config: ApiDataNetworkConfig) {
        self.router = Router(config: config)
    }

    func request<T, W>(_ target: T, decodeModel: W.Type) -> AnyPublisher<W, Error> where T: EndPointType, W: Decodable {
        let session = URLSession.shared
        do {
            let request = try router.buildRequest(from: target)
            NetworkLogger.log(request: request)
            return session.dataTaskPublisher(for: request)
                .catchNetworkError()
                .retry(2)
                .decode(type: W.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } catch {
            return Future<W, Error> { promis in
                promis(.failure(NetworkError.internalError(403)))
            }.eraseToAnyPublisher()
        }
    }

    func request<T>(_ target: T) -> AnyPublisher<Data, Error> where T: EndPointType {
        let session = URLSession.shared
        do {
            let request = try router.buildRequest(from: target)
            NetworkLogger.log(request: request)
            return session.dataTaskPublisher(for: request)
                .catchNetworkError()
                .retry(2)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } catch {
            return Future<Data, Error> { promis in
                promis(.failure(NetworkError.internalError(403)))
            }.eraseToAnyPublisher()
        }
    }
}
