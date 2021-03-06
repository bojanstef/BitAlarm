//
//  AlarmsDataServiceable.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AlarmsDataServiceable {
    func getAlarms() throws -> [Alarm]
    func deleteAlarm(_ alarm: Alarm) throws
    func updateAlarm(_ alarm: Alarm, updated: Alarm) throws
}
