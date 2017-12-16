//
//  AddAlarmPresenter.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AddAlarmPresentable {
    var navbarTitle: String { get }
}

final class AddAlarmPresenter {
    fileprivate let interactor: AddAlarmInteractable

    init(interactor: AddAlarmInteractable) {
        self.interactor = interactor
    }
}

extension AddAlarmPresenter: AddAlarmPresentable {
    var navbarTitle: String {
        return "Add Alarm"
    }
}
