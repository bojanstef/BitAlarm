//
//  NotificationService.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/24/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UserNotifications

protocol NotificationServiceable {
    func requestAuthorization(_ completionHandler: @escaping ((Bool, Error?) -> Void))
    func showNotification(for alarms: [Alarm], completion: ((Error?) -> Void)?)
}

private struct Constants {
    static let title = "Time to buy or sell!"
    static let stopActionTitle = "Stop"
    static let identifier = "ventures.stefanovic.BitAlarm.NotificationRequestIdentifier"
    static let stopActionIdentifier = "ventures.stefanovic.BitAlarm.NotificationStopActionIdentifer"
    static let categoryIdentifier = "ventures.stefanovic.BitAlarm.NotificationCategoryIdentifer"
    static let authorizationOptions: UNAuthorizationOptions = [.alert, .sound]
    static let notificationPresentationOptions: UNNotificationPresentationOptions = [.alert, .sound]
    static let notificationSound = UNNotificationSound(named: "Notification8.m4a")
    static let minRepeatInterval: TimeInterval = 60
    private init() {}
}

final class NotificationService: NSObject {
    static let `default` = NotificationService()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationService: NotificationServiceable {
    func requestAuthorization(_ completionHandler: @escaping ((Bool, Error?) -> Void)) {
        let options: UNAuthorizationOptions = Constants.authorizationOptions
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: completionHandler)
    }

    func showNotification(for alarms: [Alarm], completion: ((Error?) -> Void)?) {
        let content = UNMutableNotificationContent()
        content.title = Constants.title
        content.body = getNotificationBody(from: alarms)
        content.sound = Constants.notificationSound
        content.categoryIdentifier = Constants.categoryIdentifier
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Constants.minRepeatInterval, repeats: true)
        let stopAction = UNNotificationAction(identifier: Constants.stopActionIdentifier,
                                              title: Constants.stopActionTitle, options: [.destructive])
        let category = UNNotificationCategory(identifier: Constants.categoryIdentifier,
                                              actions: [stopAction], intentIdentifiers: [], options: [])
        let request = UNNotificationRequest(identifier: Constants.identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        stopNotifications()
        completionHandler(Constants.notificationPresentationOptions)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        stopNotifications()
        completionHandler()
    }

    private func stopNotifications() {
        let identifier = [Constants.identifier]
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifier)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifier)
    }
}

fileprivate extension NotificationService {
    func getNotificationBody(from alarms: [Alarm]) -> String {
        return alarms.enumerated().reduce("") { accum, alarm in
            let coinName = alarm.element.cryptocoin.name
            let condition = alarm.element.condition.rawValue
            let value = alarm.element.value
            let message = accum.appending("\(coinName) is \(condition) $\(value) USD")
            if alarm.offset == alarms.count - 1 {
                return message
            } else {
                return message.appending("\n")
            }
        }
    }
}
