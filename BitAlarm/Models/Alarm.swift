//
//  Alarm.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

enum Comparing: String, Codable {
    case lessThan = "<"
    case greaterThan = ">"
}

final class Alarm: NSObject, NSCoding, Codable {
    enum CodingKeys: String, CodingKey {
        case isOn = "isOn"
        case cryptocoin = "cryptocoin"
        case parameter = "parameter"
        case price = "price"
    }
    
    let isOn: Bool
    let cryptocoin: Cryptocoin
    let parameter: Comparing
    let price: Double

    init(isOn: Bool, cryptocoin: Cryptocoin, parameter: Comparing, price: Double) {
        self.isOn = isOn
        self.cryptocoin = cryptocoin
        self.parameter = parameter
        self.price = price
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Alarm else { return false }
        return isOn == object.isOn
            && cryptocoin == object.cryptocoin
            && parameter == object.parameter
            && price == object.price
    }

    // MARK: - NSCoding Protocol Methods.

    required convenience init?(coder aDecoder: NSCoder) {
        guard let cryptocoin = aDecoder.decodeObject(forKey: CodingKeys.cryptocoin.stringValue) as? Cryptocoin,
            let comparingRawValue = aDecoder.decodeObject(forKey: CodingKeys.parameter.stringValue) as? String,
            let parameter = Comparing(rawValue: comparingRawValue)
        else { print(#function); return nil }

        let isOn = aDecoder.decodeBool(forKey: CodingKeys.isOn.stringValue)
        let price = aDecoder.decodeDouble(forKey: CodingKeys.price.stringValue)

        self.init(isOn: isOn, cryptocoin: cryptocoin, parameter: parameter, price: price)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(isOn, forKey: CodingKeys.isOn.stringValue)
        aCoder.encode(cryptocoin, forKey: CodingKeys.cryptocoin.stringValue)
        aCoder.encode(parameter.rawValue, forKey: CodingKeys.parameter.stringValue)
        aCoder.encode(price, forKey: CodingKeys.price.stringValue)
    }
}
