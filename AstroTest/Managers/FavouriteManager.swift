//
//  FavouriteManager.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class FavouriteManager: NSObject {

    fileprivate static var sharedInstance: FavouriteManager!

    fileprivate var dicFavouriteChannels: [Int64: Channel] = [:]

    static func getInstance() -> FavouriteManager {
        if sharedInstance == nil {
            sharedInstance = FavouriteManager()
        }
        return sharedInstance
    }

    private override init() {

    }

    func setFavouriteChannels(_ channels: [Channel]) {

        for channel in channels {
            if let channelId = channel.channelId {
                dicFavouriteChannels[channelId] = channel
            }
        }
    }

    func getCurrentFavouriteChannels() -> [Channel] {
        return Array(dicFavouriteChannels.values)
    }

    func getDicFavouriteChannels() -> [Int64: Channel] {
        return dicFavouriteChannels
    }

    func removeItemFavouriteChannel(_ channel: Channel) {
        if let channelId = channel.channelId {
            dicFavouriteChannels.removeValue(forKey: channelId)
        }
    }

    func addItemFavouriteChannel(_ channel: Channel) {
        if let channelId = channel.channelId {
            dicFavouriteChannels[channelId] = channel
        }
    }
}
