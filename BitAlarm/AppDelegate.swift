//
//  AppDelegate.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/13/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

private struct Constants {
    static let errorTitle = "Whoops something happened 🤔"
    static let permissionTitle = "BitAlarm requires access 😄"
    static let settingsMessage = "Press Okay to open Settings and allow Notifications."
    private init() {}
}

@UIApplicationMain
final class AppDelegate: UIResponder {
    fileprivate let firstLaunchService = FirstLaunchService.default
    fileprivate let notificationService = NotificationService.default
    fileprivate let dataService = DataService.default
    fileprivate var rootCoordinator: Coordinator?
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        firstLaunchService.isFirstLaunch { getCryptocoins() }
        rootCoordinator = RootCoordinator(window: window)
        rootCoordinator?.start()
        notificationService.requestAuthorization(notificationRequestCompletion)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        application.registerForRemoteNotifications()
        return true
    }

    func applicationSignificantTimeChange(_ application: UIApplication) {
        getCryptocoins()
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pingAlarms(completionHandler)
    }

    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // TODO: - Setup Scheduling (i.e. only run this if the time is within the "active" zone.)
        pingAlarms(completionHandler)
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        dataService.saveDeviceToken(deviceToken) { error in
            print("error:", error as Any)
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // TODO: - Show error, in settings view?
        print(#function, "error:", error)
    }
}

fileprivate extension AppDelegate {
    func notificationRequestCompletion(granted: Bool, error: Error?) {
        guard error == nil else {
            createAndShowAlertController(title: Constants.errorTitle, message: Constants.settingsMessage)
            return
        }

        guard granted == true else {
            createAndShowAlertController(title: Constants.permissionTitle, message: Constants.settingsMessage)
            return
        }
    }

    func createAndShowAlertController(title: String, message: String) {
        let dismissAction = UIAlertAction(title: "Nope", style: .destructive, handler: nil)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
            if let appSettingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(dismissAction)
        alert.addAction(okayAction)
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func getCryptocoins() {
        dataService.updateCryptocoinsList()
    }

    func pingAlarms(_ completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        do {
            let enabledAlarms = try dataService.getAlarms().filter { $0.isOn }
            let dispatchGroup = DispatchGroup()
            var alarms = [Alarm]()
            enabledAlarms.forEach { alarm in
                dispatchGroup.enter()
                dataService.updateCryptocoin(alarm.cryptocoin) { cryptocoin in
                    guard let cryptocoin = cryptocoin else { dispatchGroup.leave(); return }
                    if alarm.shouldActivate(given: cryptocoin) {
                        alarms.append(alarm)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) { [weak self] in
                if alarms.isEmpty {
                    completionHandler(.noData)
                } else {
                    self?.activate(alarms, completionHandler: completionHandler)
                }
            }
        } catch {
            completionHandler(.failed); print(#function, error)
        }
    }

    func activate(_ alarms: [Alarm], completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        notificationService.showNotification(for: alarms) { error in
            if let error = error {
                completionHandler(.failed); print(#function, error)
            } else {
                completionHandler(.newData)
            }
        }
    }
}
