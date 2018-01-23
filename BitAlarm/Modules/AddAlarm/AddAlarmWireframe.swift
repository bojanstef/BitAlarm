//
//  AddAlarmWireframe.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

protocol AddAlarmModuleDelegate: class {}

final class AddAlarmWireframe {
    fileprivate weak var moduleDelegate: AddAlarmModuleDelegate?

    init(moduleDelegate: AddAlarmModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension AddAlarmWireframe {
    var controller: UIViewController {
        let dataService: AddAlarmDataServiceable = DataService.default
        let interactor = AddAlarmInteractor(moduleDelegate: moduleDelegate, dataService: dataService)
        let presenter = AddAlarmPresenter(interactor: interactor)
        let viewController = AddAlarmViewController(presenter: presenter)
        return UINavigationController(rootViewController: viewController)
    }
}
