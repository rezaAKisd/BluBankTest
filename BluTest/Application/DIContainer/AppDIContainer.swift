//
//  AppDIContainer.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation
import RealmSwift

final class AppDIContainer {
    // MARK: - Network

    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: AppConfiguration.apiBaseURL)!,
                                          queryParameters: [:],
                                          timeoutInterval: 10)
        return NetworkProvider(config: config)
    }()

    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: AppConfiguration.imageBaseURL)!,
                                          timeoutInterval: 10)
        return NetworkProvider(config: config)
    }()
    
    lazy var imageCacheService: RealmCRUD = {
        let username = "Images"
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(username)
        config.fileURL!.appendPathExtension("realm")
        
        return RealmStorage(config: config)
    }()
}
