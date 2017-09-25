//
//  ProfileViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("profile", comment: "").uppercased()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        let backBarButton = UIBarButtonItem(image: UIImage(named: "ic_nav_back"), style: .done, target: self, action: #selector(actionTapToBackBtn))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton

        let saveBarButton = UIBarButtonItem(title: NSLocalizedString("save", comment: "").uppercased(), style: .done, target: self, action: #selector(actionTapToSaveBtn))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorMain, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15) ?? UIFont.systemFontSize], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func actionTapToBackBtn() {
        navigationController?.popViewController(animated: true)
    }

    func actionTapToSaveBtn() {
        navigationController?.popViewController(animated: true)
    }
}
