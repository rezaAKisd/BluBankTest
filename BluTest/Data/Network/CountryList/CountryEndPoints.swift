//
//  CountryEndPoints.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Foundation

enum CountryEndPoints {
    case getCountryList
}

extension CountryEndPoints: EndPointType {
    var httpMethod: HTTPMethod {
        .get
    }

    var task: HTTPTask {
        .request
    }

    var baseURL: URL {
        switch self {
        case .getCountryList:
            return URL(string: AppConfiguration.apiBaseURL)!
        }
    }

    var headers: [String: String]? {
        nil
    }

    public var path: String {
        switch self {
        case .getCountryList:
            return "v3.1/all"
        }
    }
}
