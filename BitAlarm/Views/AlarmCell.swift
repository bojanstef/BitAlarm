//
//  AlarmCell.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

protocol AlarmCellDelegate: class {
    func switchWasFlipped(for alarm: Alarm)
}

protocol AlarmCellSetupable {
    func setup(_ alarm: Alarm)
}

final class AlarmCell: UITableViewCell {
    @IBOutlet fileprivate weak var isActiveSwitch: UISwitch!
    @IBOutlet fileprivate weak var symbolLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    fileprivate var alarm: Alarm?
    weak var delegate: AlarmCellDelegate?
    override var reuseIdentifier: String? { return String(describing: AlarmCell.self) }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        editingAccessoryType = .disclosureIndicator
    }
}

extension AlarmCell: AlarmCellSetupable {
    func setup(_ alarm: Alarm) {
        self.alarm = alarm

        isActiveSwitch.setOn(alarm.isOn, animated: false)
        isActiveSwitch.addTarget(self, action: .switchWasFlipped, for: .valueChanged)

        symbolLabel.attributedText = NSAttributedString(string: alarm.cryptocoin.symbol, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 48)
        ])

        
        let text = "When \(alarm.cryptocoin.name) is \(alarm.condition.rawValue) $\(alarm.value) USD"
        descriptionLabel.attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.lightGray,
        ])
    }
}

fileprivate extension AlarmCell {
    @objc func switchWasFlipped() {
        guard let alarm = alarm else { print(#function); return }
        delegate?.switchWasFlipped(for: alarm)
    }
}

fileprivate extension Selector {
    static let switchWasFlipped = #selector(AlarmCell.switchWasFlipped)
}
