//
//  DataService.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case endpoint
    case noData
}

protocol DataServiceable {
    func updateCryptocoinsList()
    func updateCryptocoin(_ cryptocoin: Cryptocoin, completion: @escaping ((Cryptocoin?) -> Void))
    func saveDeviceToken(_ deviceToken: Data, completion: @escaping ((Error?) -> Void))
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
        let stringURL = "https://api.coinmarketcap.com/v1/ticker/?limit=0"
        guard let endpoint = URL(string: stringURL) else { print(#function); return }
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: endpoint) { [weak self] data, _, error in
                do {
                    guard let data = data else { throw NSError(domain: #function, code: 420, userInfo: nil) }
                    let cryptocoins = try JSONDecoder().decode([Cryptocoin].self, from: data)
                    try self?.cacheService.saveObject(cryptocoins, in: .cryptocoins)
                } catch {
                    print(#function, error)
                }
            }.resume()
        }
    }

    func updateCryptocoin(_ cryptocoin: Cryptocoin, completion: @escaping ((Cryptocoin?) -> Void)) {
        let stringURL = "https://api.coinmarketcap.com/v1/ticker/\(cryptocoin.uid)/"
        guard let endpoint = URL(string: stringURL) else { print(#function); completion(nil); return }
        URLSession.shared.dataTask(with: endpoint) { data, _, error in
            do {
                guard let data = data else { throw NSError(domain: #function, code: 17, userInfo: nil) }
                let cryptocoins = try JSONDecoder().decode([Cryptocoin].self, from: data)
                completion(cryptocoins.first)
            } catch {
                completion(nil)
                print(#function, error)
            }
        }.resume()
    }

    func saveDeviceToken(_ deviceToken: Data, completion: @escaping ((Error?) -> Void)) {
        let stringURL = "https://bitalarm.herokuapp.com/device_token" // "http://mbp.local:5000/device_token"
        guard let endpoint = URL(string: stringURL) else { completion(BackendError.endpoint); return }
        let deviceToken = DeviceToken(tokenData: deviceToken)
        do {
            let json = try JSONEncoder().encode(deviceToken)
            let request = generatePostRequest(at: endpoint, json: json)
            URLSession.shared.dataTask(with: request) { data, response, error in
                completion(error)
            }.resume()
        } catch {
            completion(error)
        }
    }
}

extension DataService: AlarmsDataServiceable {
    func getAlarms() throws -> [Alarm] {
        guard let alarms = try cacheService.getObject(.alarms) as? [Alarm] else {
            throw NSError(domain: #function, code: 69, userInfo: nil)
        }

        return alarms
    }

    func deleteAlarm(_ alarm: Alarm) throws {
        try cacheService.deleteAlarm(alarm)
    }

    func updateAlarm(_ alarm: Alarm, updated: Alarm) throws {
        try cacheService.updateAlarm(alarm, updated: updated)
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
        try cacheService.saveAlarm(alarm)
    }
}

fileprivate extension DataService {
    func generatePostRequest(at endpoint: URL, json: Data) -> URLRequest {
        var request = URLRequest(url: endpoint)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = json
        return request
    }
}
