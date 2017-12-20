//
//  Alarm.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

enum Condition: String, Codable {
    case lessThan = "less than"
    case greaterThan = "greater than"
}

final class Alarm: NSObject, NSCoding, Codable {
    enum CodingKeys: String, CodingKey {
        case isOn
        case cryptocoin
        case condition
        case value
    }

    let isOn: Bool
    let cryptocoin: Cryptocoin
    let condition: Condition
    let value: String

    init(isOn: Bool, cryptocoin: Cryptocoin, condition: Condition, value: String) {
        self.isOn = isOn
        self.cryptocoin = cryptocoin
        self.condition = condition
        self.value = value
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Alarm else { return false }
        return isOn == object.isOn
            && cryptocoin == object.cryptocoin
            && condition == object.condition
            && value == object.value
    }

    // MARK: - NSCoding Protocol Methods.

    required convenience init?(coder aDecoder: NSCoder) {
        guard let cryptocoin = aDecoder.decodeObject(forKey: CodingKeys.cryptocoin.stringValue) as? Cryptocoin,
            let conditionRawValue = aDecoder.decodeObject(forKey: CodingKeys.condition.stringValue) as? String,
            let condition = Condition(rawValue: conditionRawValue),
            let value = aDecoder.decodeObject(forKey: CodingKeys.value.stringValue) as? String
        else { print(#function); return nil }

        let isOn = aDecoder.decodeBool(forKey: CodingKeys.isOn.stringValue)
        self.init(isOn: isOn, cryptocoin: cryptocoin, condition: condition, value: value)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(isOn, forKey: CodingKeys.isOn.stringValue)
        aCoder.encode(cryptocoin, forKey: CodingKeys.cryptocoin.stringValue)
        aCoder.encode(condition.rawValue, forKey: CodingKeys.condition.stringValue)
        aCoder.encode(value, forKey: CodingKeys.value.stringValue)
    }
}
