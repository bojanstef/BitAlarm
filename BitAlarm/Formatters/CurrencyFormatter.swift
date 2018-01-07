//
//  CurrencyFormatter.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/19/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

final class CurrencyFormatter: NumberFormatter {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init() {
        super.init()
        numberStyle = .currency
        currencySymbol = ""
        minimumFractionDigits = 2
        maximumFractionDigits = 8
        isLenient = true
    }

    func formattedText(from string: String) -> String {
        let number = self.number(from: string) ?? 0
        let text = self.string(from: number) ?? "0"
        return text
    }
}
