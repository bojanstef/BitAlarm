//
//  AlarmsInteractor.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AlarmsInteractable {
    func showAddAlarmController()
    func getAlarms() throws -> [Alarm]
    func deleteAlarm(_ alarm: Alarm) throws
}

final class AlarmsInteractor {
    fileprivate weak var moduleDelegate: AlarmsModuleDelegate?
    fileprivate let dataService: AlarmsDataServiceable

    init(moduleDelegate: AlarmsModuleDelegate?, dataService: AlarmsDataServiceable) {
        self.moduleDelegate = moduleDelegate
        self.dataService = dataService
    }
}

extension AlarmsInteractor: AlarmsInteractable {
    func showAddAlarmController() {
        moduleDelegate?.showAddAlarmController()
    }

    func getAlarms() throws -> [Alarm] {
        return try dataService.getAlarms()
    }

    func deleteAlarm(_ alarm: Alarm) throws {
        try dataService.deleteAlarm(alarm)
    }
}
