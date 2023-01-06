//
//  CountryEndPoints.swift
//  BluTest
//
//  Created by reza akbari on 1/6/23.
//

import Foundation
import Moya

enum CountryEndPoints {
    case getCountryList
}

extension CountryEndPoints: TargetType {
    public var baseURL: URL {
        switch self {
        case .getCountryList:
            return URL(string: AppConfiguration.apiBaseURL)!
        }
    }

    public var headers: [String: String]? {
        nil
    }

    public var method: Moya.Method {
        return .get
    }

    public var path: String {
        switch self {
        case .getCountryList:
            return "v3.1/all"
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case .getCountryList:
            return .requestPlain
        }
    }

    public var validationType: ValidationType {
        return .successAndRedirectCodes
    }

    var authorizationType: AuthorizationType? {
        .none
    }
}

