//
//  OnNowCollectionViewCell.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/26/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class OnNowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var onNowBtn: UIButton!

    static let kCellId = "OnNowCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        onNowBtn.layer.cornerRadius = 5
    }
}
