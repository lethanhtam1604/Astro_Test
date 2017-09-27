//
//  TimeCollectionViewCell.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/26/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var timeLabel: UILabel!

    static let kCellId = "TimeCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func bindingData(_ time: Time) {
        if time.type {
            timeLabel.text = String(time.value) + " AM"
        } else {
            timeLabel.text = String(time.value) + " PM"
        }
    }
}
