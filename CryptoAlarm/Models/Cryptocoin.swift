//
//  Cryptocoin.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

final class Cryptocoin: NSObject, NSCoding, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case marketCapUSD = "market_cap_usd"
    }

    let id: String
    let name: String
    let symbol: String
    let marketCapUSD: String

    init(id: String, name: String, symbol: String, marketCapUSD: String) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.marketCapUSD = marketCapUSD
    }

    // MARK: - NSCoding Protocol Methods.

    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: CodingKeys.id.stringValue) as? String,
            let name = aDecoder.decodeObject(forKey: CodingKeys.name.stringValue) as? String,
            let symbol = aDecoder.decodeObject(forKey: CodingKeys.symbol.stringValue) as? String,
            let marketCapUSD = aDecoder.decodeObject(forKey: CodingKeys.marketCapUSD.stringValue) as? String
        else { return nil }

        self.init(id: id, name: name, symbol: symbol, marketCapUSD: marketCapUSD)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: CodingKeys.id.stringValue)
        aCoder.encode(name, forKey: CodingKeys.name.stringValue)
        aCoder.encode(symbol, forKey: CodingKeys.symbol.stringValue)
        aCoder.encode(marketCapUSD, forKey: CodingKeys.marketCapUSD.stringValue)
    }
}

extension Cryptocoin: Comparable {
    static func <(lhs: Cryptocoin, rhs: Cryptocoin) -> Bool {
        if let lhsMarketCapUSD = Double(lhs.marketCapUSD), let rhsMarketCapUSD = Double(rhs.marketCapUSD) {
            return lhsMarketCapUSD < rhsMarketCapUSD
        } else {
            return lhs.name < rhs.name
        }
    }
}
