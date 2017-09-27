//
//  TimeManager.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/26/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class TimeManager: NSObject {

    fileprivate static var sharedInstance: TimeManager!

    fileprivate var times: [Time] = []

    static func getInstance() -> TimeManager {
        if sharedInstance == nil {
            sharedInstance = TimeManager()
        }
        return sharedInstance
    }

    private override init() {

        times.append(Time(0, true))

        for index in 1...11 {
            times.append(Time(index, true))
        }

        times.append(Time(12, false))

        for index in 13...23 {
            times.append(Time(index, false))
        }

        times.append(Time(0, true))
        times.append(Time(1, true))
        times.append(Time(2, true))
    }

    func getTimes() -> [Time] {
        return times
    }
}
