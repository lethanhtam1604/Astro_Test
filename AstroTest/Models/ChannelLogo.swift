//
//  ChannelLogo.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/23/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ChannelLogo: NSObject {

    var system: String?
    var subSystem: String?
    var value: String?

    override init() {
        super.init()
    }

    init(_ channelLogo: [String : Any]) {
        system = channelLogo["system"] as? String
        subSystem = channelLogo["subSystem"] as? String
        value = channelLogo["value"] as? String
    }
}
