//
//  AddAlarmDataServiceable.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol AddAlarmDataServiceable {
    func getCryptocoins() throws -> [Cryptocoin]
    func saveAlarm(_ alarm: Alarm) throws 
}
