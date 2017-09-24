//
//  ChannelTableViewCell.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var logoImgView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var numberLabel: UILabel!
    @IBOutlet fileprivate weak var favouriteBtn: UIButton!

    static let kCellId = "ChannelTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        let favouriteImg = UIImage(named: "ic_favourite")
        let favouriteTintedImg = favouriteImg?.withRenderingMode(.alwaysTemplate)
        favouriteBtn.setImage(favouriteTintedImg, for: .normal)
        favouriteBtn.tintColor = Global.colorGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func bindingData(_ channel: Channel) {
        titleLabel.text = channel.channelTitle

        if let number = channel.channelStbNumber {
            numberLabel.text = "CH " + number
        }

        if let path = channel.currentChannelLogo?.value {
            logoImgView.loadImagesUsingUrlString(urlString: path)
        }
    }

    @IBAction func actionTapToFavouriteBtn(_ sender: Any) {
        let favouriteImg = UIImage(named: "ic_favourite")
        let favouriteTintedImg = favouriteImg?.withRenderingMode(.alwaysTemplate)
        favouriteBtn.setImage(favouriteTintedImg, for: .normal)
        favouriteBtn.tintColor = Global.colorMain
    }
}
