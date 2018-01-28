//
//  Cryptocoin.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

final class Cryptocoin: NSObject, NSCoding, Codable {
    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case symbol
        case value = "price_usd"
        case marketCapUSD = "market_cap_usd"
    }

    let uid: String
    let name: String
    let symbol: String
    let value: String?
    let marketCapUSD: String?

    init(uid: String, name: String, symbol: String, value: String?, marketCapUSD: String?) {
        self.uid = uid
        self.name = name
        self.symbol = symbol
        self.value = value
        self.marketCapUSD = marketCapUSD
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Cryptocoin else { return false }
        return uid == object.uid
            && name == object.name
            && symbol == object.symbol
            && value == object.value
            && marketCapUSD == object.marketCapUSD
    }

    // MARK: - NSCoding Protocol Methods.

    required convenience init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: CodingKeys.uid.stringValue) as? String,
            let name = aDecoder.decodeObject(forKey: CodingKeys.name.stringValue) as? String,
            let symbol = aDecoder.decodeObject(forKey: CodingKeys.symbol.stringValue) as? String
        else { print(#function); return nil }

        let value = aDecoder.decodeObject(forKey: CodingKeys.value.stringValue) as? String
        let marketCapUSD = aDecoder.decodeObject(forKey: CodingKeys.marketCapUSD.stringValue) as? String

        self.init(uid: uid, name: name, symbol: symbol, value: value, marketCapUSD: marketCapUSD)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: CodingKeys.uid.stringValue)
        aCoder.encode(name, forKey: CodingKeys.name.stringValue)
        aCoder.encode(symbol, forKey: CodingKeys.symbol.stringValue)
        aCoder.encode(value, forKey: CodingKeys.value.stringValue)
        aCoder.encode(marketCapUSD, forKey: CodingKeys.marketCapUSD.stringValue)
    }
}

extension Cryptocoin: Comparable {
    static func < (lhs: Cryptocoin, rhs: Cryptocoin) -> Bool {
        let rhsMarketCapUSDString = rhs.marketCapUSD ?? "0"
        let rhsMarketCapUSD = Double(rhsMarketCapUSDString) ?? 0
        let lhsMarketCapUSDString = lhs.marketCapUSD ?? "0"
        let lhsMarketCapUSD = Double(lhsMarketCapUSDString) ?? 0
        return lhsMarketCapUSD < rhsMarketCapUSD
    }
}
