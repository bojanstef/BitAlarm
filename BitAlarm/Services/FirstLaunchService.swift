//
//  FirstLaunchService.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/17/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import Foundation

protocol FirstLaunchServiceable {
    func isFirstLaunch(_ completion: (() -> Void))
}

private struct Constants {
    static let hasBeenLaunchedKey = "ventures.stefanovic.BitAlarm.HasBeenLaunched"
    private init() {}
}

final class FirstLaunchService {
    static let `default` = FirstLaunchService()
    private init() {}
}

extension FirstLaunchService: FirstLaunchServiceable {
    func isFirstLaunch(_ completion: (() -> Void)) {
        if UserDefaults.standard.bool(forKey: Constants.hasBeenLaunchedKey) == false {
            setHasBeenLaunched()
            completion()
        }
    }
}

fileprivate extension FirstLaunchService {
    func setHasBeenLaunched() {
        UserDefaults.standard.set(true, forKey: Constants.hasBeenLaunchedKey)
    }
}
