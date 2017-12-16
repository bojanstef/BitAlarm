//
//  AlarmsPresenter.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AlarmsPresentable {
    var navbarTitle: String { get }
    func showAddAlarmController()
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

    func showAddAlarmController() {
        interactor.showAddAlarmController()
    }
}
