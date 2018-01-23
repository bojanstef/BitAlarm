//
//  AddAlarmPresenter.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AddAlarmPresentable {
    var navbarTitle: String { get }
    var currencySymbol: String { get }
    var currencyCode: String { get }
    var bitcoin: Cryptocoin { get }
    func getCryptocoins() throws -> [Cryptocoin]
    func saveAlarm(_ alarm: Alarm) throws
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

    var currencySymbol: String {
        return "$"
    }

    var currencyCode: String {
        return "USD"
    }

    var bitcoin: Cryptocoin {
        return Cryptocoin(uid: "bitcoin", name: "Bitcoin", symbol: "BTC", value: "+inf", marketCapUSD: "+inf")
    }

    func getCryptocoins() throws -> [Cryptocoin] {
        return try interactor.getCryptocoins()
    }

    func saveAlarm(_ alarm: Alarm) throws {
        try interactor.saveAlarm(alarm)
    }
}
