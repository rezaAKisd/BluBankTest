//
//  AnyPublisher+Ext.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import Foundation
import Moya

extension AnyPublisher where Output == Response, Failure == MoyaError {
    func catchNetworkError() -> AnyPublisher<Response, NetworkError> {
        return self.unwrapThrowable { response in
            response
        }
    }
}

extension AnyPublisher where Output == Response, Failure == MoyaError {
    // Workaround for a lot of things, actually. We don't have Publishers.Once, flatMap
    // that can throw and a lot more. So this monster was created because of that. Sorry.
    func unwrapThrowable<T>(throwable: @escaping (Output) throws -> T) -> AnyPublisher<T, NetworkError> {
        self.tryMap { element in
            try throwable(element)
        }
        .mapError { error -> NetworkError in
            resolve(error: error)
        }
        .eraseToAnyPublisher()
    }

    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}
