//
//  AlarmsInteractor.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AlarmsInteractable {
    func showAddAlarmController()
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
}
