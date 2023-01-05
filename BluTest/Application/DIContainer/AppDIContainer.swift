//
//  AppDIContainer.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation
import Moya

final class AppDIContainer {
    // MARK: - Network

    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: AppConfiguration.apiBaseURL)!,
                                          queryParameters: [:],
                                          timeoutInterval: 10)
        return NetworkProvider(config: config)
    }()
}
