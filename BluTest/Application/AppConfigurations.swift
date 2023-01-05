//
//  AppConfigurations.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

final class AppConfiguration {
    static var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
