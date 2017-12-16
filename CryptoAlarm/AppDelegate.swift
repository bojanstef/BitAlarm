//
//  AppDelegate.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/13/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rootCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        rootCoordinator = RootCoordinator(window: window)
        rootCoordinator?.start()
        return true
    }
}
