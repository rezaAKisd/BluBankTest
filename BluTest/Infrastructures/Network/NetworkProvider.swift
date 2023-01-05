//
//  NetworkProvider.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import CombineMoya
import Foundation
import Moya

public protocol DataTransferService {
    @discardableResult
    func request<T: TargetType, W: Decodable>(_ target: T, decodeModel: W.Type) -> AnyPublisher<W, Error>

    @discardableResult
    func request<T: TargetType>(_ target: T) -> AnyPublisher<Data, Error>
}

final class NetworkProvider: DataTransferService {
    private let provider: MoyaProvider<MultiTarget>

    init(config: ApiDataNetworkConfig) {
        self.provider = MoyaProvider<MultiTarget>(config: config)
    }

    func request<T, W>(_ target: T, decodeModel: W.Type) -> AnyPublisher<W, Error> where T: TargetType, W: Decodable {
        return self.provider.requestPublisher(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .catchNetworkError()
            .map(\.data)
            .retry(2)
            .decode(type: W.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func request<T>(_ target: T) -> AnyPublisher<Data, Error> where T: Moya.TargetType {
        return self.provider.requestPublisher(MultiTarget(target))
            .filterSuccessfulStatusCodes()
            .catchNetworkError()
            .map(\.data)
            .mapError { $0 as Error }
            .retry(2)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
