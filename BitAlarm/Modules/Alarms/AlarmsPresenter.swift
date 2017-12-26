//
//  AlarmsPresenter.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

protocol AlarmsPresentable {
    var navbarTitle: String { get }
    var headerButtonTitle: NSAttributedString { get }
    func showAddAlarmController()
    func showDowntimeScheduleController()
    func getAlarms() throws -> [Alarm]
    func deleteAlarm(_ alarm: Alarm) throws
    func updateAlarm(_ alarm: Alarm, updated: Alarm) throws
}

final class AlarmsPresenter {
    fileprivate let interactor: AlarmsInteractable

    init(interactor: AlarmsInteractable) {
        self.interactor = interactor
    }
}

extension AlarmsPresenter: AlarmsPresentable {
    var navbarTitle: String {
        return (Bundle.main.object(forInfoDictionaryKey: String(kCFBundleNameKey)) as? String) ?? "BitAlarm"
    }

    var headerButtonTitle: NSAttributedString {
        let string = "Activated alarms have no downtime."
        return NSAttributedString(string: string, attributes: [
            .font: UIFont.systemFont(ofSize: 12)
        ])
    }

    func showAddAlarmController() {
        interactor.showAddAlarmController()
    }

    func showDowntimeScheduleController() {
        interactor.showDowntimeScheduleController()
    }

    func getAlarms() throws -> [Alarm] {
        return try interactor.getAlarms()
    }

    func deleteAlarm(_ alarm: Alarm) throws {
        try interactor.deleteAlarm(alarm)
    }

    func updateAlarm(_ alarm: Alarm, updated: Alarm) throws {
        try interactor.updateAlarm(alarm, updated: updated)
    }
}
