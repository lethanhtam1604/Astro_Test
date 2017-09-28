//
//  TVGuideCollectionViewCell.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/26/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class TVGuideCollectionViewCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!

    static let kCellId = "TVGuideCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = Global.colorSeparator.cgColor
        layer.borderWidth = 0.5
    }

    func bindingData(_ event: Event) {
        nameLabel.text = event.programmeTitle

        if let displayDateTime = event.displayDateTime {
            timeLabel.text = DateUtil.stringTime(displayDateTime, format: DateUtil.DateFormat.yyyymmddhhmmssS)
        } else {
            timeLabel.text = ""
        }

        let earlierTime = DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " 00:00:00.0"

        let beginTime = event.displayDateTime ?? ""
        let beginMinute = DateUtil.minutes(earlierTime, beginTime, format: DateUtil.DateFormat.yyyymmddhhmmssS)

        let nowTime = DateUtil.string()
        let nowMinute = DateUtil.minutes(earlierTime, nowTime, format: DateUtil.DateFormat.yyyymmddhhmmssS)

        var durationTime = ""
        if let displayDuration = event.displayDuration {
            durationTime = DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " " + displayDuration + ".0"
        }

        let durationMinutes = DateUtil.minutesFromDate(durationTime, format: DateUtil.DateFormat.yyyymmddhhmmssS)

        if nowMinute >= beginMinute && nowMinute < durationMinutes + beginMinute {
            backgroundColor = Global.colorGray
        } else {
            backgroundColor = UIColor.white
        }
    }
}
