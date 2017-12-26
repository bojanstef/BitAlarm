//
//  AlarmsWireframe.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

protocol AlarmsModuleDelegate: class {
    func showAddAlarmController()
    func showDowntimeScheduleController()
}

final class AlarmsWireframe {
    fileprivate weak var moduleDelegate: AlarmsModuleDelegate?

    init(moduleDelegate: AlarmsModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension AlarmsWireframe {
    var controller: UIViewController {
        let dataService: AlarmsDataServiceable = DataService.default
        let interactor = AlarmsInteractor(moduleDelegate: moduleDelegate, dataService: dataService)
        let presenter = AlarmsPresenter(interactor: interactor)
        return AlarmsViewController(presenter: presenter)
    }
}
