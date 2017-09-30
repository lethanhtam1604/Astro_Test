//
//  ChannelDetailViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ChannelDetailViewController: BaseViewController {

    @IBOutlet fileprivate weak var channelLogoImgView: UIImageView!
    @IBOutlet fileprivate weak var channelNumberLabel: UILabel!
    @IBOutlet fileprivate weak var favouriteBtn: UIButton!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!

    fileprivate var favouriteTintedImg: UIImage!
    var channel: Channel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = channel.channelTitle

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        let backBarButton = UIBarButtonItem(image: UIImage(named: "ic_nav_back"), style: .done, target: self, action: #selector(actionTapToBackBtn))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton

        //setting UI
        channelLogoImgView.layer.cornerRadius = 5
        let favouriteImg = UIImage(named: "ic_favourite")
        favouriteTintedImg = favouriteImg?.withRenderingMode(.alwaysTemplate)
        favouriteBtn.setImage(favouriteTintedImg, for: .normal)

        //load Data
        if let path = channel.currentChannelLogo?.value {
            channelLogoImgView.loadImagesUsingUrlString(urlString: path)
        } else {
            channelLogoImgView.image = nil
        }

        if let channelDescription = channel.channelDescription {
            descriptionLabel.text = channelDescription
        }

        if let channelStbNumber = channel.channelStbNumber {
            channelNumberLabel.text = "CH " + channelStbNumber
        } else {
            channelNumberLabel.text = ""
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func actionTapToFavouriteBtn(_ sender: Any) {
        if favouriteBtn.tintColor == Global.colorGray {
            setFavourite()
            DatabaseHelper.getInstance().saveChannel(channel)
            FavouriteManager.getInstance().addItemFavouriteChannel(channel)
        } else {
            setUnFavourite()
            DatabaseHelper.getInstance().deleteChannel(channel)
            FavouriteManager.getInstance().removeItemFavouriteChannel(channel)
        }
    }

    @objc func actionTapToBackBtn() {
        navigationController?.popViewController(animated: true)
    }
}
