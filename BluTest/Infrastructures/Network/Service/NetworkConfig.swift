//
//  NetworkConfig.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    var timeoutInterval: TimeInterval { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    public let headers: [String: String]
    public let queryParameters: [String: String]
    public var timeoutInterval: TimeInterval

    public init(baseURL: URL,
                headers: [String: String] = [:],
                queryParameters: [String: String] = [:],
                timeoutInterval: TimeInterval = 15) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
        self.timeoutInterval = timeoutInterval
    }
}
