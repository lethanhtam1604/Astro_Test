//
//  ChannelsViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class ChannelsViewController: BaseViewController {

    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = Global.colorMain
        return refreshControl
    }()
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tableView: UITableView!

    let channelPresenter = ChannelPresenter()
    var channels: [Channel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CHANNELS"

        //custom search bar
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search for channels"
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
        tableView.separatorColor = Global.colorSeparator
        let cellNib = UINib(nibName: ChannelTableViewCell.kCellId, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: ChannelTableViewCell.kCellId)
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)

        //load Data
        channelPresenter.attachView(view: self)
        channelPresenter.getChannels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        channelPresenter.getChannels()
    }
}

extension ChannelsViewController: ChannelView {

    func startLoading() {
        refreshControl.tintColor = Global.colorMain
        refreshControl.beginRefreshing()
    }

    func finishLoading() {
        refreshControl.endRefreshing()
    }

    func setChannels(channels: [Channel]?) {
        if let channelList = channels {
            self.channels = channelList
            tableView.reloadData()
        }
    }
}

extension ChannelsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.kCellId, for: indexPath) as! ChannelTableViewCell //swiftlint:disable:this force_cast
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero

        cell.bindingData(channels[indexPath.row])

        return cell
    }
}

extension ChannelsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChannelsViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
}
