//
//  DataTaskPublisher+Ext.swift
//  BluTest
//
//  Created by reza akbari on 1/8/23.
//

import Combine
import Foundation

extension URLSession.DataTaskPublisher {
    func catchNetworkError() -> AnyPublisher<Data, Error> {
        self.tryMap { data, response throws -> Data in
            NetworkLogger.log(response: response, data: data)
            guard let httpResponse = response as? HTTPURLResponse,
                  200 ..< 300 ~= httpResponse.statusCode
            else {
                switch (response as? HTTPURLResponse)?.statusCode ?? 400 {
                case 400 ... 499:
                    throw NetworkError.internalError((response as? HTTPURLResponse)?.statusCode ?? 400)
                default:
                    throw NetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? 500)
                }
            }
            return data
        }.eraseToAnyPublisher()
    }
}
