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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController?.view.backgroundColor = .white

        window?.makeKeyAndVisible()

        return true
    }
}
