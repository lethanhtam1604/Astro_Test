//
//  UserDefaultManager.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {

    fileprivate static var sharedInstance: UserDefaultManager!

    fileprivate let defaults = UserDefaults.standard

    fileprivate let channelStatusSort = "channelStatusSort"

    static func getInstance() -> UserDefaultManager {
        if sharedInstance == nil {
            sharedInstance = UserDefaultManager()
        }
        return sharedInstance
    }

    private override init() {

    }

    func setChannelStatusSort(value: Int) {
        defaults.set(value, forKey: channelStatusSort)
        defaults.synchronize()
    }

    func getChannelStatusSort() -> Int {
        return defaults.integer(forKey: channelStatusSort)
    }
}
