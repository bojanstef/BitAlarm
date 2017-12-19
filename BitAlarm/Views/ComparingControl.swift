//
//  ComparingControl.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

final class ComparingControl: UISegmentedControl {
    var comparer: Comparing {
        if selectedSegmentIndex == 0 {
            return .lessThan
        } else {
            return .greaterThan
        }
    }
}
