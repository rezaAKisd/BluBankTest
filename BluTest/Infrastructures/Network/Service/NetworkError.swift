//
//  NetworkError.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

enum NetworkError: Error {
    case parametersNil
    case encodingFailed
    case missingURL
    
    case internalError(_ statusCode: Int)
    case serverError(_ statusCode: Int)
}
