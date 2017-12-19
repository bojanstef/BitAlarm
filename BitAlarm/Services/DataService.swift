//
//  DataService.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol DataServiceable {
    func updateCryptocoinsList()
}

final class DataService {
    fileprivate let cacheService: CacheServiceable
    static let `default` = DataService(cacheService: CacheService.default)

    private init(cacheService: CacheServiceable) {
        self.cacheService = cacheService
    }
}

extension DataService: DataServiceable {
    func updateCryptocoinsList() {
        let stringURL = "https://api.coinmarketcap.com/v1/ticker/?limit=120"
        guard let endpoint = URL(string: stringURL) else { print(#function); return }
        URLSession.shared.dataTask(with: endpoint) { [weak self] data, response, error in
            do {
                guard let data = data else { throw NSError(domain: #function, code: 420, userInfo: nil) }
                let cryptocoins = try JSONDecoder().decode([Cryptocoin].self, from: data)
                try self?.cacheService.saveObject(cryptocoins, in: .cryptocoins)
            } catch {
                print(error)
            }
        }.resume()
    }
}

extension DataService: AlarmsDataServiceable {
    func getAlarms() throws -> [Alarm] {
        guard let alarms = try cacheService.getObject(.alarms) as? [Alarm] else {
            throw NSError(domain: #function, code: 69, userInfo: nil)
        }

        return alarms
    }
}

extension DataService: AddAlarmDataServiceable {
    func getCryptocoins() throws -> [Cryptocoin] {
        guard let cryptocoins = try cacheService.getObject(.cryptocoins) as? [Cryptocoin] else {
            throw NSError(domain: #function, code: 1337, userInfo: nil)
        }

        return cryptocoins.sorted(by: >)
    }

    func saveAlarm(_ alarm: Alarm) throws {
        let alarms = [alarm] // TODO: - Remove
        try cacheService.saveObject(alarms, in: .alarms)
    }
}
