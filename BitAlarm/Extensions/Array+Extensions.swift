//
//  Array+Extensions.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/17/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

extension Array where Element == Cryptocoin {
    var dictionary: Dictionary<String, Cryptocoin> {
        return reduce([:]) { result, cryptocoin in
            var dict = result
            dict[cryptocoin.id] = cryptocoin
            return dict
        }
    }
}
