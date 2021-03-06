//
//  CryptocoinCell.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/18/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

protocol CryptocoinCellSetupable {
    func setup(_ cryptocoin: Cryptocoin)
}

final class CryptocoinCell: UITableViewCell {
    @IBOutlet fileprivate weak var coinNameLabel: UILabel!
    @IBOutlet fileprivate weak var coinValueLabel: UILabel!
    override var reuseIdentifier: String? { return String(describing: CryptocoinCell.self) }
    var cryptocoin: Cryptocoin?
}

extension CryptocoinCell: CryptocoinCellSetupable {
    func setup(_ cryptocoin: Cryptocoin) {
        self.cryptocoin = cryptocoin
        coinNameLabel.text = cryptocoin.name

        let formattedValue = CurrencyFormatter().formattedText(from: cryptocoin.value)
        let text = "About $\(formattedValue) USD"
        coinValueLabel.attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.lightGray
        ])
    }
}
