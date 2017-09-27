//
//  ChannelCollectionViewCell.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/26/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var channelLogoImgView: UIImageView!
    @IBOutlet fileprivate weak var numberLabel: UILabel!
    @IBOutlet fileprivate weak var favouriteBtn: UIButton!

    static let kCellId = "ChannelCollectionViewCell"

    fileprivate var favouriteTintedImg: UIImage!
    fileprivate var currentChannel: Channel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = Global.colorSeparator.cgColor
        layer.borderWidth = 0.5

        let favouriteImg = UIImage(named: "ic_favourite")
        favouriteTintedImg = favouriteImg?.withRenderingMode(.alwaysTemplate)
        favouriteBtn.setImage(favouriteTintedImg, for: .normal)

        setUnFavourite()
    }

    func bindingData(_ channel: Channel) {
        currentChannel = channel

        if let number = channel.channelStbNumber {
            numberLabel.text = "CH " + number
        } else {
            numberLabel.text = ""
        }

        if let path = channel.currentChannelLogo?.value {
            channelLogoImgView.loadImagesUsingUrlString(urlString: path)
        } else {
            channelLogoImgView.image = nil
        }

        if let channelId = channel.channelId {
            let dicChannels = FavouriteManager.getInstance().getDicFavouriteChannels()
            if dicChannels[channelId] != nil {
                setFavourite()
            } else {
                setUnFavourite()
            }
        } else {
            setUnFavourite()
        }
    }

    func setFavourite() {
        favouriteBtn.tintColor = Global.colorMain
    }

    func setUnFavourite() {
        favouriteBtn.tintColor = Global.colorGray
    }

    @IBAction func actionTapToFavouriteBtn(_ sender: Any) {
        if favouriteBtn.tintColor == Global.colorGray {
            setFavourite()
            DatabaseHelper.getInstance().saveChannel(currentChannel)
            FavouriteManager.getInstance().addItemFavouriteChannel(currentChannel)
        } else {
            setUnFavourite()
            DatabaseHelper.getInstance().deleteChannel(currentChannel)
            FavouriteManager.getInstance().removeItemFavouriteChannel(currentChannel)
        }
    }
}
