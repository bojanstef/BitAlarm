//
//  DeviceToken.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 1/3/18.
//  Copyright © 2018 Stefanovic Ventures. All rights reserved.
//

import Foundation

final class DeviceToken: Codable {
    enum CodingKeys: String, CodingKey {
        case _timeCreated = "time_created" // swiftlint:disable:this identifier_name
        case value
    }

    private let _timeCreated: TimeInterval
    let value: String
    var timeCreated: Date? { return TimeFormatter().date(from: _timeCreated) }

    convenience init(tokenData: Data) {
        let value = tokenData.reduce("") { $0 + String(format: "%02x", $1) }
        self.init(timeCreated: Date().timeIntervalSince1970, value: value)
    }

    init(timeCreated: TimeInterval, value: String) {
        self._timeCreated = timeCreated
        self.value = value
    }
}
