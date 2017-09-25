//
//  SortTableViewCell.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var nameLabel: UILabel!

    static let kCellId = "SortTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func bindingData(_ channelStatusCheck: Bool, _ title: String) {
        bindingDataHeightForCell(title)

        if channelStatusCheck {
            checkmarkCell()
        } else {
            unCheckmarkCell()
        }
    }

    func checkmarkCell() {
        accessoryType = .checkmark
        nameLabel.textColor = Global.colorMain
    }

    func unCheckmarkCell() {
        accessoryType = .none
        nameLabel.textColor = UIColor.black
    }
}

extension SortTableViewCell {

    func bindingDataHeightForCell(_ title: String) {
        nameLabel.text = title
    }

    func heightForCell() -> CGFloat {

        let nameHeight = NSString(string: nameLabel.text ?? "").boundingRect(with: CGSize(width: frame.width - 24 - 5, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: nameLabel.font], context: nil)

        return nameHeight.height + 30
    }
}
