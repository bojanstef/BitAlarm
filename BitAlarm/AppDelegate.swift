//
//  AppDelegate.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/13/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder {
    var window: UIWindow?
    var rootCoordinator: Coordinator?
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let window = window else { return false }
        FirstLaunchService.default.isFirstLaunch { getCryptocoins() }
        rootCoordinator = RootCoordinator(window: window)
        rootCoordinator?.start()
        return true
    }

    func applicationSignificantTimeChange(_ application: UIApplication) {
        getCryptocoins()
    }
}

fileprivate extension AppDelegate {
    func getCryptocoins() {
        DispatchQueue.main.async { DataService.default.updateCryptocoinsList() }
    }
}
