//
//  AppDelegate.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?
    let appDIContainer = AppDIContainer()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController()
        window?.rootViewController?.view.backgroundColor = .white

        let navigationController = window?.rootViewController as? UINavigationController ?? UINavigationController()
        coordinator = AppCoordinator(navigationController: navigationController, appDIContainer: appDIContainer)
        coordinator?.start()

        window?.makeKeyAndVisible()
        return true
    }
}
