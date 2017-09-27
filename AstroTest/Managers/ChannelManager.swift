//
//  ChannelManager.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/26/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ChannelManager: NSObject {

    fileprivate static var sharedInstance: ChannelManager!

    fileprivate var channels: [Channel] = []

    static func getInstance() -> ChannelManager {
        if sharedInstance == nil {
            sharedInstance = ChannelManager()
        }
        return sharedInstance
    }

    private override init() {

    }

    func setChannels(_ channels: [Channel]) {
        self.channels = channels
    }

    func getChannels() -> [Channel] {
        return channels
    }
}
