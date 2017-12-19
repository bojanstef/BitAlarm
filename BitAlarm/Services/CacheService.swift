//
//  CacheService.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/17/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

enum Cachefilenames: String {
    case cryptocoins = "ventures.stefanovic.BitAlarm.Cryptocoins.plist"
    case alarms = "ventures.stefanovic.BitAlarm.Alarms.plist"
}

protocol CacheServiceable {
    func saveAlarm(_ alarm: Alarm) throws
    func deleteAlarm(_ alarmToRemove: Alarm) throws
    func saveObject(_ object: Any, in filename: Cachefilenames) throws
    func getObject(_ filename: Cachefilenames) throws -> Any?
}

final class CacheService {
    static let `default` = CacheService()
    private init() {}
}

extension CacheService: CacheServiceable {
    func saveAlarm(_ alarm: Alarm) throws {
        let alarms = try getObject(.alarms) as? [Alarm] ?? []
        try saveObject(alarms + [alarm], in: .alarms)
    }

    func deleteAlarm(_ alarmToRemove: Alarm) throws {
        guard let alarms = try getObject(.alarms) as? [Alarm] else {
            throw NSError(domain: #function, code: 1080, userInfo: nil)
        }
        let updatedAlarms = alarms.filter { $0 != alarmToRemove }
        try saveObject(updatedAlarms, in: .alarms)
    }

    func saveObject(_ object: Any, in filename: Cachefilenames) throws {
        let file = try getFile(filename).path
        if !NSKeyedArchiver.archiveRootObject(object, toFile: file) {
            throw NSError(domain: #function, code: 360, userInfo: nil)
        }
    }
    
    func getObject(_ filename: Cachefilenames) throws -> Any? {
        let file = try getFile(filename).path
        return NSKeyedUnarchiver.unarchiveObject(withFile: file)
    }
}

fileprivate extension CacheService {
    func getFile(_ filename: Cachefilenames) throws -> URL {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let url = documentDirectoryURL else { throw NSError(domain: #function, code: 666, userInfo: nil) }
        return url.appendingPathComponent(filename.rawValue)
    }
}
