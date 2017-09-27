//
//  MainViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {

    fileprivate var channelsViewController: ChannelsViewController!
    fileprivate var tvGuideViewController: TVGuideViewController!
    fileprivate var favouritesViewController: FavouritesViewController!
    fileprivate var settingsViewController: SettingsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        view.tintColor = Global.colorMain
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = UIColor.white
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = false

        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorGray, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10) ?? UIFont.systemFontSize], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorMain, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10) ?? UIFont.systemFontSize], for: .selected)

        var storyboard = UIStoryboard(name: "Channels", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ChannelsViewController") as? ChannelsViewController {
            channelsViewController = viewController
        }

        storyboard = UIStoryboard(name: "TVGuide", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "TVGuideViewController") as? TVGuideViewController {
            tvGuideViewController = viewController
        }

        storyboard = UIStoryboard(name: "Favourites", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as? FavouritesViewController {
            favouritesViewController = viewController
        }

        storyboard = UIStoryboard(name: "Settings", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            settingsViewController = viewController
        }

        let channelsBarItem = UITabBarItem(title: NSLocalizedString("channels", comment: "").uppercased(), image: UIImage(named: "ic_channel"), tag: 1)
        channelsViewController.tabBarItem = channelsBarItem
        let nc1 = UINavigationController(rootViewController: channelsViewController)

        let tvGuideBarItem = UITabBarItem(title: NSLocalizedString("tv_guide", comment: "").uppercased(), image: UIImage(named: "ic_tv"), tag: 2)
        tvGuideViewController.tabBarItem = tvGuideBarItem
        let nc2 = UINavigationController(rootViewController: tvGuideViewController)

        let favouritesBarItem = UITabBarItem(title: NSLocalizedString("favourites", comment: "").uppercased(), image: UIImage(named: "ic_favourite"), tag: 3)
        favouritesViewController.tabBarItem = favouritesBarItem
        let nc3 = UINavigationController(rootViewController: favouritesViewController)

        let settingsBarItem = UITabBarItem(title: NSLocalizedString("settings", comment: "").uppercased(), image: UIImage(named: "ic_setting"), tag: 4)
        settingsViewController.tabBarItem = settingsBarItem
        let nc4 = UINavigationController(rootViewController: settingsViewController)

        self.viewControllers = [nc1, nc2, nc3, nc4]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch Global.currentWorkFlow {
        case WorkFlow.splashScreen.hashValue:
            let storyboard = UIStoryboard(name: "SplashScreen", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "SplashScreenViewController") as? SplashScreenViewController {
                navigationController?.pushViewController(viewController, animated: false)
            }
        case WorkFlow.mainScreen.hashValue:
            break
        default:
            break
        }

        Global.currentWorkFlow = WorkFlow.nothing.hashValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate var previousTag = 1

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.tag == 1 && previousTag == 1 {
            if let tableView = channelsViewController.getTableView() {
                let indexPath = NSIndexPath(row: 0, section: 0)
                tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        } else if item.tag == 2 && previousTag == 2 {
            if let collectionView = tvGuideViewController.getCollectionView() {
                let indexPath = NSIndexPath(row: 0, section: 1)
                collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            }
        } else if item.tag == 3 && previousTag == 3 {
            if let tableView = favouritesViewController.getTableView() {
                let indexPath = NSIndexPath(row: 0, section: 0)
                tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        }

        previousTag = item.tag
    }
}
