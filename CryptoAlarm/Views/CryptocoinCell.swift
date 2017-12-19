//
//  CryptocoinCell.swift
//  CryptoAlarm
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
    override var reuseIdentifier: String? { return String(describing: CryptocoinCell.self) }
    var cryptocoin: Cryptocoin?
}

extension CryptocoinCell: CryptocoinCellSetupable {
    func setup(_ cryptocoin: Cryptocoin) {
        self.cryptocoin = cryptocoin
        coinNameLabel.text = cryptocoin.name
    }
}
