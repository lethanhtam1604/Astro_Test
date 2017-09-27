//
//  Channel.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class Channel: NSObject {

    var channelId: Int64?
    var channelStbNumber: String?
    var channelTitle: String?
    var channelDescription: String?
    var channelLogos: [ChannelLogo] = []
    var currentChannelLogo: ChannelLogo?

    override init() {

    }

    init(_ channel: [String : Any]) {
        channelId = channel["channelId"] as? Int64
        channelStbNumber = channel["channelStbNumber"] as? String
        channelTitle = channel["channelTitle"] as? String
        channelDescription = channel["channelDescription"] as? String

        if let channelLogos = channel["channelExtRef"] as? [[String: Any]] {
            for channelLogo in channelLogos {
                let channelLogo = ChannelLogo(channelLogo)
                self.channelLogos.append(channelLogo)

                if currentChannelLogo == nil {
                    if let subSystem = channelLogo.subSystem {
                        if subSystem.range(of:"Pos") != nil {
                            currentChannelLogo = channelLogo
                        }
                    }
                }
            }
        }
    }
}
