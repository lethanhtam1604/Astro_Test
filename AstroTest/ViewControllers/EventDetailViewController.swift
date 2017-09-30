//
//  EventDetailViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/28/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController {

    @IBOutlet fileprivate weak var channelLogoImgView: UIImageView!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    
    var event: Event!
    var channel: Channel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = event.programmeTitle

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        let backBarButton = UIBarButtonItem(image: UIImage(named: "ic_nav_back"), style: .done, target: self, action: #selector(actionTapToBackBtn))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton

        //setting UI
        channelLogoImgView.layer.cornerRadius = 5

        //load Data
        if let path = channel.currentChannelLogo?.value {
            channelLogoImgView.loadImagesUsingUrlString(urlString: path)
        } else {
            channelLogoImgView.image = nil
        }

        if let displayDateTime = event.displayDateTime {
            timeLabel.text = DateUtil.stringTime(displayDateTime, format: DateUtil.DateFormat.yyyymmddhhmmssS)
        } else {
            timeLabel.text = ""
        }

        descriptionLabel.text = event.shortSynopsis
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @objc func actionTapToBackBtn() {
        navigationController?.popViewController(animated: true)
    }
}
