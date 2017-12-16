//
//  DataService.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

final class DataService {
    static let `default` = DataService()

    private init() {}
}

extension DataService: AlarmsDataServiceable {}
extension DataService: AddAlarmDataServiceable {}
