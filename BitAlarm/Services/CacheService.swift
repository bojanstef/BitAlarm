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
    func saveAlarm(_ alarmToSave: Alarm) throws
    func deleteAlarm(_ alarmToRemove: Alarm) throws
    func updateAlarm(_ alarmToUpdate: Alarm, updated: Alarm) throws
    func saveObject(_ object: Any, in filename: Cachefilenames) throws
    func getObject(_ filename: Cachefilenames) throws -> Any?
}

final class CacheService {
    static let `default` = CacheService()
    fileprivate var alarms = [Alarm]()
    private init() {
        self.alarms = (try? getObject(.alarms) as? [Alarm] ?? []) ?? []
    }
}

extension CacheService: CacheServiceable {
    func saveAlarm(_ alarmToSave: Alarm) throws {
        alarms.append(alarmToSave)
        try saveObject(alarms, in: .alarms)
    }

    func deleteAlarm(_ alarmToRemove: Alarm) throws {
        guard let index = alarms.index(of: alarmToRemove) else { throw NSError(domain: #function, code: 1080, userInfo: nil) }
        alarms.remove(at: index)
        try saveObject(alarms, in: .alarms)
    }

    func updateAlarm(_ alarmToUpdate: Alarm, updated: Alarm) throws {
        guard let index = alarms.index(of: alarmToUpdate) else { throw NSError(domain: #function, code: 420, userInfo: nil) }
        alarms[index] = updated
        try saveObject(alarms, in: .alarms)
    }

    func saveObject(_ object: Any, in filename: Cachefilenames) throws {
        let file = try getFile(filename).path
        if !NSKeyedArchiver.archiveRootObject(object, toFile: file) { throw NSError(domain: #function, code: 360, userInfo: nil) }
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
