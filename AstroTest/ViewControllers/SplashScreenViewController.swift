//
//  SplashScreenViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseViewController {

    @IBOutlet fileprivate weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        titleLabel.increaseSize()

        Global.currentWorkFlow = WorkFlow.mainScreen.hashValue
        navigateToMainPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        titleLabel.layer.removeAllAnimations()
    }

    func navigateToMainPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigationController?.popViewController(animated: false)
        }
    }
}
