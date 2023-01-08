//
//  HTTPTask.swift
//  BluTest
//
//  Created by reza akbari on 1/8/23.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case request

    case requestParameters(bodyParameters: Parameters?,
                           bodyEncoding: ParameterEncoding,
                           urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)
}
