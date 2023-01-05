//
//  AppConfigurations.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

final class AppConfiguration {
    static var apiBaseURL: String = {
        guard let apiBaseURL = infoForKey("ApiBaseURL") else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()

    static var imageBaseURL: String = {
        guard let apiBaseURL = infoForKey("ApiBaseURL") else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()

    private static func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
}
