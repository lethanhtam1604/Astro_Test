//
//  ChannelDetailViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ChannelDetailViewController: BaseViewController {

    var channel: Channel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = channel.channelTitle

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        let backBarButton = UIBarButtonItem(image: UIImage(named: "ic_nav_back"), style: .done, target: self, action: #selector(actionTapToBackBtn))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func actionTapToBackBtn() {
        navigationController?.popViewController(animated: true)
    }
}
