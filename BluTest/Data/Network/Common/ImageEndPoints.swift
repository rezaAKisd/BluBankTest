//
//  ImageEndPoints.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

enum ImageEndPoints {
    case getMoviePoster(path: String)
}

extension ImageEndPoints: EndPointType {
    var httpMethod: HTTPMethod {
        .get
    }

    var task: HTTPTask {
        .request
    }

    var baseURL: URL {
        switch self {
        case .getMoviePoster:
            return URL(string: AppConfiguration.imageBaseURL)!
        }
    }

    var headers: [String: String]? {
        nil
    }

    var path: String {
        switch self {
        case .getMoviePoster(let path):
            return path.replacingOccurrences(of: "\(AppConfiguration.imageBaseURL)", with: "")
        }
    }
}
