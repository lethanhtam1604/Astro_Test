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
    func setSearchChannels(channels: [Channel]?)
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
        DispatchQueue.global().sync {
            FavouriteManager.getInstance().setFavouriteChannels(DatabaseHelper.getInstance().getChannels() ?? [Channel]())
        }
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

            ChannelManager.getInstance().setChannels(result ?? [Channel]())

            self?.channelView?.setChannels(channels: result)
            self?.channelView?.finishLoading()
        }
    }

    func searchChannels(_ searchString: String?, _ channels: [Channel]) {

        DispatchQueue.global().async {
            var result = [Channel]()

            let searchText = searchString ?? ""

            if searchText.isEmpty {
                result.append(contentsOf: channels)
            } else {
                let text = searchText.lowercased()

               result = channels.filter({ (channel) -> Bool in
                    if (channel.channelTitle?.lowercased().contains(text)) ?? false ||
                        (channel.channelStbNumber?.lowercased().contains(text) ?? false) {
                        return true
                    }

                    return false
                })
            }

            DispatchQueue.main.async {
                self.channelView?.setSearchChannels(channels: result)
            }
        }
    }

    func sortChannels(_ channels: [Channel]) {
        channelView?.startLoading()

        DispatchQueue.global().async {
            let result = channels.sorted(by: { (s0, s1) -> Bool in

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

            DispatchQueue.main.async {
                self.channelView?.setChannels(channels: result)
                self.channelView?.finishLoading()
            }
        }
    }
}
