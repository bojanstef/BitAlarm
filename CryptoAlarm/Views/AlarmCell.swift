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
        symbolLabel.text = alarm.symbol
        descriptionLabel.text = "\(alarm.symbol) \(alarm.parameter.rawValue) \(alarm.price)"
    }
}
