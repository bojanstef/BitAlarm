//
//  AlarmsPresenter.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AlarmsPresentable {
    var navbarTitle: String { get }
    var dataDescription: String { get }
    func showAddAlarmController()
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

    var dataDescription: String {
        return "All data is from coinmarketcap.com"
    }

    func showAddAlarmController() {
        interactor.showAddAlarmController()
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
