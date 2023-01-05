//
//  MoyaProvider+Ext.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Combine
import CombineMoya
import Foundation
import Moya

extension MoyaProvider {
    convenience init(config: NetworkConfigurable) {
        self.init(requestClosure: MoyaProvider.requestResolver(config: config))
    }

    // Additional change on request
    static func requestResolver(config: NetworkConfigurable) -> MoyaProvider<Target>.RequestClosure {
        return { endpoint, closure in
            do {
                var request = try endpoint.urlRequest()

                config.headers.forEach { key, value in
                    request.addValue(value, forHTTPHeaderField: key)
                }

                config.queryParameters.forEach { key, value in
                    request.url?.appendQueryItem(name: key, value: value)
                }

                request.timeoutInterval = config.timeoutInterval

                closure(.success(request))
            } catch {
                closure(.failure(.requestMapping("couldn't get request")))
            }
        }
    }
}
