//
//  AddAlarmInteractor.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AddAlarmInteractable {
    func getCryptocoins() throws -> [Cryptocoin]
    func saveAlarm(_ alarm: Alarm) throws
}

final class AddAlarmInteractor {
    fileprivate weak var moduleDelegate: AddAlarmModuleDelegate?
    fileprivate let dataService: AddAlarmDataServiceable

    init(moduleDelegate: AddAlarmModuleDelegate?, dataService: AddAlarmDataServiceable) {
        self.moduleDelegate = moduleDelegate
        self.dataService = dataService
    }
}

extension AddAlarmInteractor: AddAlarmInteractable {
    func getCryptocoins() throws -> [Cryptocoin] {
        return try dataService.getCryptocoins()
    }

    func saveAlarm(_ alarm: Alarm) throws {
        try dataService.saveAlarm(alarm)
    }
}
