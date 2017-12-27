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
    static let identifier = "ventures.stefanovic.BitAlarm.NotificationRequestIdentifier"
    static let contentIdentifier = "ventures.stefanovic.BitAlarm.NotificationContentIdentifier"
    static let notificationSound = UNNotificationSound(named: "Notification7.m4a")
    static let minRepeatInterval: TimeInterval = 60
    private init() {}
}

final class NotificationService {
    static let `default` = NotificationService()
    private init() {}
}

extension NotificationService: NotificationServiceable {
    func requestAuthorization(_ completionHandler: @escaping ((Bool, Error?) -> Void)) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: completionHandler)
    }

    func showNotification(for alarms: [Alarm], completion: ((Error?) -> Void)?) {
        let content = UNMutableNotificationContent()
        content.title = Constants.title
        content.body = getNotificationBody(from: alarms)
        content.categoryIdentifier = Constants.contentIdentifier + UUID().uuidString
        content.sound = Constants.notificationSound
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Constants.minRepeatInterval, repeats: true)
        let identifier = Constants.identifier + UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
}

fileprivate extension NotificationService {
    func getNotificationBody(from alarms: [Alarm]) -> String {
        return alarms.reduce("") { accum, alarm in
            accum.appending("\(alarm.cryptocoin.name) is \(alarm.condition.rawValue) $\(alarm.value) USD\n")
        }
    }
}
