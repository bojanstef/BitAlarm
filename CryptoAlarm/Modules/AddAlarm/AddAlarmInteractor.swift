//
//  AddAlarmInteractor.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AddAlarmInteractable {}

final class AddAlarmInteractor {
    fileprivate weak var moduleDelegate: AddAlarmModuleDelegate?
    fileprivate let dataService: AddAlarmDataServiceable

    init(moduleDelegate: AddAlarmModuleDelegate?, dataService: AddAlarmDataServiceable) {
        self.moduleDelegate = moduleDelegate
        self.dataService = dataService
    }
}

extension AddAlarmInteractor: AddAlarmInteractable {}
