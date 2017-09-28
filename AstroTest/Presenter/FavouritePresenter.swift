//
//  FavouritePresenter.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

protocol FavouriteView: class {
    func startLoading()
    func finishLoading()
    func setChannels(channels: [Channel]?)
    func setSearchChannels(channels: [Channel]?)
}

class FavouritePresenter: NSObject {

    weak private var favouriteView: FavouriteView?

    func attachView(view: FavouriteView) {
        favouriteView = view
    }

    func detachView() {
        favouriteView = nil
    }

    func getChannels() {
        favouriteView?.startLoading()
        DispatchQueue.global().async {
            let channels = FavouriteManager.getInstance().getCurrentFavouriteChannels()
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
                self.favouriteView?.setChannels(channels: result)
                self.favouriteView?.finishLoading()
            }
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
                self.favouriteView?.setSearchChannels(channels: result)
            }
        }
    }

    func sortChannels(_ channels: [Channel]) {
        favouriteView?.startLoading()

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
                self.favouriteView?.setChannels(channels: result)
                self.favouriteView?.finishLoading()
            }
        }
    }
}
