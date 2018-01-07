//
//  TimeFormatter.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 1/3/18.
//  Copyright © 2018 Stefanovic Ventures. All rights reserved.
//

import Foundation

final class TimeFormatter: DateFormatter {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init() {
        super.init()
        dateStyle = .long
        timeStyle = .long
    }

    func date(from timeIntervalSince1970: TimeInterval) -> Date? {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let dateString = self.string(from: date)
        return self.date(from: dateString)
    }
}
