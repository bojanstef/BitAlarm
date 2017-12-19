//
//  AlarmCell.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

protocol AlarmCellSetupable {
    func setup(_ alarm: Alarm)
}

final class AlarmCell: UITableViewCell {
    @IBOutlet fileprivate weak var isActiveSwitch: UISwitch!
    @IBOutlet fileprivate weak var symbolLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    override var reuseIdentifier: String? { return String(describing: AlarmCell.self) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        editingAccessoryType = .disclosureIndicator
    }
}

extension AlarmCell: AlarmCellSetupable {
    func setup(_ alarm: Alarm) {
        isActiveSwitch.setOn(alarm.isOn, animated: false)

        symbolLabel.attributedText = NSAttributedString(string: alarm.cryptocoin.symbol, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 48)
        ])

        let text = "\(alarm.cryptocoin.name) \(alarm.parameter.rawValue) $\(alarm.price) USD"
        descriptionLabel.attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray,
        ])
    }
}

