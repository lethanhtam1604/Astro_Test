//
//  TVGuidePresenter.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/26/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

protocol TVGuideView: class {
    func startLoading()
    func finishLoading()
    func setChannels(channels: [Channel]?)
    func setSearchChannels(channels: [Channel]?)
    func setEvents(events: [Event]?)
}

class TVGuidePresenter: NSObject {

    weak private var tvGuideView: TVGuideView?

    fileprivate var count = 0
    fileprivate var begin = 0

    func attachView(view: TVGuideView) {
        tvGuideView = view
    }

    func detachView() {
        tvGuideView = nil
    }

    func getChannels() {
        tvGuideView?.startLoading()
        DispatchQueue.global().sync {
            FavouriteManager.getInstance().setFavouriteChannels(DatabaseHelper.getInstance().getChannels() ?? [Channel]())
        }
        begin = 0
        count = 0
        APIHelper.getChannels { [weak self] (_, channels) in

            let result = channels?.sorted(by: { (s0, s1) -> Bool in

                if UserDefaultManager.getInstance().getChannelStatusSort() == 0 {
                    if let number1 = s0.channelStbNumber, let number2 = s1.channelStbNumber {
                        return number1 < number2
                    }
                } else {
                    if let title1 = s0.channelTitle, let title2 = s1.channelTitle {
                        return title1 < title2
                    }
                }

                return false
            })

            self?.tvGuideView?.finishLoading()
            self?.tvGuideView?.setChannels(channels: result)
        }
    }

    func isCanLoadMore(_ channels: [Channel]) -> Bool {
        if count >= channels.count {
            return false
        }

        return true
    }

    func loadSectionMore(_ channels: [Channel]) {
        begin = count
        if count + 10 <= channels.count {
            count += 10
        } else {
            count = channels.count
        }
    }

    func getNumberOfSection() -> Int {
        return count
    }

    func getEvents(_ channels: [Channel], _ periodStart: String, _ periodEnd: String) {
        tvGuideView?.startLoading()
        var channelIds: [Int64] = []
        for index in begin..<count {
            if let channelId = channels[index].channelId {
                channelIds.append(channelId)
            }
        }

        APIHelper.getEvents(channelIds, periodStart, periodEnd) { [weak self] (_, events) in

            let result = events?.sorted(by: { (s0, s1) -> Bool in
                if let displayDateTime1 = s0.displayDateTime, let displayDateTime2 = s1.displayDateTime {
                    return displayDateTime1 < displayDateTime2
                }
                return false
            })

            self?.tvGuideView?.setEvents(events: result)
            self?.tvGuideView?.finishLoading()
        }
    }
}
