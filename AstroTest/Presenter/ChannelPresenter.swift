//
//  ChannelPresenter.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/23/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

protocol ChannelView: class {
    func startLoading()
    func finishLoading()
    func setChannels(channels: [Channel]?)
}

class ChannelPresenter: NSObject {

    weak private var channelView: ChannelView?

    func attachView(view: ChannelView) {
        channelView = view
    }

    func detachView() {
        channelView = nil
    }

    func getChannels() {
        channelView?.startLoading()
        APIHelper.getChannels { [weak self] (_, channels) in

            let result = channels?.sorted(by: { (s0, s1) -> Bool in
                if let number1 = s0.channelStbNumber, let number2 = s1.channelStbNumber {
                    return number1 < number2
                }

                return false
            })

            self?.channelView?.setChannels(channels: result)
            self?.channelView?.finishLoading()
        }
    }
}
