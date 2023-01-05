//
//  NetworkError.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

public extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }

    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}
