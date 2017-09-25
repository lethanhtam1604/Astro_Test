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

    fileprivate let channelPresenter = ChannelPresenter()
    fileprivate var channels: [Channel] = []
    fileprivate var allChannels: [Channel] = []
    fileprivate var isLoadData = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CHANNELS"

        //setting UI
        let filterBarButton = UIBarButtonItem(image: UIImage(named: "ic_filter"), style: .done, target: self, action: #selector(actionTapToSortBtn))
        navigationItem.leftBarButtonItem = filterBarButton

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
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: ChannelTableViewCell.kCellId, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: ChannelTableViewCell.kCellId)
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)

        //load Data
        channelPresenter.attachView(view: self)
        channelPresenter.getChannels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isLoadData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        isLoadData = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        channelPresenter.getChannels()
    }

    func actionTapToSortBtn() {
        let storyboard = UIStoryboard(name: "Channels", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "SortChannelViewController") as? SortChannelViewController {
            viewController.delegate = self
            let nav = UINavigationController(rootViewController: viewController)
            present(nav, animated: true, completion: nil)
        }
    }
}

extension ChannelsViewController: ChannelView {

    func startLoading() {
        refreshControl.beginRefreshing()
    }

    func finishLoading() {
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

extension ChannelsViewController: SortChannelDelegate {

    func applySort() {
        channelPresenter.sortChannels(allChannels)
    }
}

extension ChannelsViewController: UITableViewDataSource {

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

extension ChannelsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.kCellId) as! ChannelTableViewCell  //swiftlint:disable:this force_cast
        cell.bindingDataHeightForCell(channels[indexPath.row])

        return cell.heightForCell()
    }

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
        channelPresenter.searchChannels(searchBar.text, allChannels)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        channelPresenter.searchChannels(searchBar.text, allChannels)
    }
}
