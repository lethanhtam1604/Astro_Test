//
//  SettingsViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet fileprivate weak var profileView: UIView!
    @IBOutlet fileprivate weak var logoutView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("settings", comment: "").uppercased()

        profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionTapToProfileView)))
        logoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionTapToLogoutView)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func actionTapToProfileView() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func actionTapToLogoutView() {
        let alertController = UIAlertController(title: NSLocalizedString("logout", comment: ""), message: NSLocalizedString("logout_message", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in
            //write func for logout here...
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
