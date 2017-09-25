//
//  ChannelTableViewCell.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var logoImgView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var favouriteBtn: UIButton!

    static let kCellId = "ChannelTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 2
        containerView.layer.masksToBounds = false

        let favouriteImg = UIImage(named: "ic_favourite")
        let favouriteTintedImg = favouriteImg?.withRenderingMode(.alwaysTemplate)
        favouriteBtn.setImage(favouriteTintedImg, for: .normal)
        favouriteBtn.tintColor = Global.colorGray

        logoImgView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func bindingData(_ channel: Channel) {

        bindingDataHeightForCell(channel)

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

extension ChannelTableViewCell {

    func bindingDataHeightForCell(_ channel: Channel) {

        var channelTitle = ""
        var channelStbNumber = ""

        if let title = channel.channelTitle {
            channelTitle += title + "\n"
        }

        if let number = channel.channelStbNumber {
            channelStbNumber += "CH " + number
        }

        let wholeStr = "\(channelTitle)\(channelStbNumber)"

        let attributedString = NSMutableAttributedString(string: wholeStr)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain, range: (wholeStr as NSString).range(of: channelTitle))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: (wholeStr as NSString).range(of: channelStbNumber))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans", size: 14) ?? UIFont.systemFontSize, range: (wholeStr as NSString).range(of: channelStbNumber))
        titleLabel.attributedText = attributedString

        DispatchQueue.main.async {
            self.containerView.layer.shadowPath = UIBezierPath(rect: self.containerView.bounds).cgPath
        }
    }

    func heightForCell() -> CGFloat {

        var titleHeight: CGFloat = 0

        if let attribute = titleLabel.attributedText {
            titleHeight = (attribute.height(withConstrainedWidth: frame.width - 120 - 45))
        }

        if titleHeight < 100 {
            titleHeight = 100
        }

        titleHeight += 20

        return titleHeight
    }
}
