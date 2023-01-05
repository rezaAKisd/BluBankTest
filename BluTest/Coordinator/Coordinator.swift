//
//  Coordinator.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func coordinate(to coordinator: Coordinator)
    func removeFromParent()
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }

    func removeFromParent() {
        childCoordinators.removeAll()
    }
}
