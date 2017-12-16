//
//  RootCoordinator.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

final class RootCoordinator {
    let rootNavigationController = UINavigationController()
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
}

extension RootCoordinator: Coordinator {
    func start() {
        let rootController = AlarmsWireframe(moduleDelegate: self).controller
        rootNavigationController.pushViewController(rootController, animated: false)
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
    }
}

extension RootCoordinator: AlarmsModuleDelegate {
    func showAddAlarmController() {
        let controller = AddAlarmWireframe(moduleDelegate: self).controller
        rootNavigationController.present(controller, animated: true, completion: nil)
    }
}

extension RootCoordinator: AddAlarmModuleDelegate {}
