//
//  FavouritesViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class FavouritesViewController: BaseViewController {

    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = Global.colorMain
        return refreshControl
    }()
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var indicator: UIActivityIndicatorView!

    fileprivate let favouritePresenter = FavouritePresenter()
    fileprivate var channels: [Channel] = []
    fileprivate var allChannels: [Channel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("favourites", comment: "").uppercased()

        //setting UI
        let sortBarButton = UIBarButtonItem(image: UIImage(named: "ic_sort"), style: .done, target: self, action: #selector(actionTapToSortBtn))
        navigationItem.leftBarButtonItem = sortBarButton
        
        //custom search bar
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = NSLocalizedString("search_for_favourites", comment: "")
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.clear
        searchBar.tintColor = Global.colorMain
        searchBar.endEditing(true)

        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UITextField.self) {
                    let textField: UITextField = subview as! UITextField //swiftlint:disable:this force_cast
                    textField.backgroundColor = UIColor.clear
                    break
                }
            }
        }

        //setup tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: ChannelTableViewCell.kCellId, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: ChannelTableViewCell.kCellId)
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)

        favouritePresenter.attachView(view: self)
        indicator.startAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //load Data
        favouritePresenter.getChannels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func actionTapToSortBtn() {
        let storyboard = UIStoryboard(name: "Channels", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "SortChannelViewController") as? SortChannelViewController {
            viewController.delegate = self
            let nav = UINavigationController(rootViewController: viewController)
            present(nav, animated: true, completion: nil)
        }
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        favouritePresenter.getChannels()
    }
}

extension FavouritesViewController: SortChannelDelegate {

    func applySort() {
        Global.isUpdateChannelsBySorting = false
        Global.isUpdateTVGuideBySorting = false
        favouritePresenter.sortChannels(channels)
    }
}

extension FavouritesViewController: FavouriteView {

    func startLoading() {

    }

    func finishLoading() {
        indicator.stopAnimating()
        refreshControl.endRefreshing()
    }

    func setChannels(channels: [Channel]?) {
        if let channelList = channels {
            self.allChannels = channelList
            self.channels = channelList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func setSearchChannels(channels: [Channel]?) {
        if let channelList = channels {
            self.channels = channelList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension FavouritesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.kCellId, for: indexPath) as! ChannelTableViewCell //swiftlint:disable:this force_cast
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none

        cell.bindingData(channels[indexPath.row])

        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let storyboard = UIStoryboard(name: "ChannelDetail", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ChannelDetailViewController") as? ChannelDetailViewController {
            viewController.channel = channels[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.kCellId) as! ChannelTableViewCell  //swiftlint:disable:this force_cast
        cell.bindingDataHeightForCell(channels[indexPath.row])

        return cell.heightForCell()
    }
}

extension FavouritesViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        favouritePresenter.searchChannels(searchBar.text, allChannels)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        favouritePresenter.searchChannels(searchBar.text, allChannels)
    }
}

extension FavouritesViewController {

    func getTableView() -> UITableView? {
        if tableView != nil {
            return tableView
        }

        return nil
    }
}
