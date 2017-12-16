//
//  Alarm.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

enum Comparable: String {
    case lessThan = "<"
    case greaterThan = ">"
}

struct Alarm {
    let isOn: Bool
    let symbol: String
    let parameter: Comparable
    let price: Double
}
