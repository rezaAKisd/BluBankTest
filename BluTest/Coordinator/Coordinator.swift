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
    func removeChild(for coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }

    func removeChild(for coordinator: Coordinator) {
        guard !childCoordinators.isEmpty,
              let removeIndex = childCoordinators.firstIndex(where: { $0 === coordinator }) else { return }
        childCoordinators.remove(at: removeIndex)
    }
}

protocol CoordinateBackDelegate: AnyObject {
    func navigateBackToFirstPage(coordinator: Coordinator)
}
