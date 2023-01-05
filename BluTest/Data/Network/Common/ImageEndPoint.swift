//
//  ImageEndPoint.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation
import Moya

enum ImageEndPoints {
    case getMoviePoster(path: String)
}

extension ImageEndPoints: TargetType {
    public var baseURL: URL {
        switch self {
        case .getMoviePoster:
            return URL(string: AppConfiguration.imageBaseURL)!
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
        case .getMoviePoster(let path):
            return path.replacingOccurrences(of: "\(AppConfiguration.imageBaseURL)", with: "")
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case .getMoviePoster:
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
