//
//  TVGuideViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit
import SVProgressHUD

class TVGuideViewController: BaseViewController {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!

    fileprivate var customCollectionViewLayout: CustomCollectionViewLayout!
    var index = 1

    fileprivate let tvGuidePresenter = TVGuidePresenter()
    fileprivate var channels: [Channel] = []
    fileprivate var isLoadData = false
    fileprivate var times: [Time] = TimeManager.getInstance().getTimes()
    fileprivate var isLoadMore = true
    fileprivate var events: [[Event]] = [[]]
    fileprivate var dicEvents: [Int: [Event]] = [:]

    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = Global.colorMain
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("tv_guide", comment: "").uppercased()

        //setup collectionView
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: OnNowCollectionViewCell.kCellId, bundle: nil), forCellWithReuseIdentifier: OnNowCollectionViewCell.kCellId)
        collectionView.register(UINib(nibName: TimeCollectionViewCell.kCellId, bundle: nil), forCellWithReuseIdentifier: TimeCollectionViewCell.kCellId)
        collectionView.register(UINib(nibName: ChannelCollectionViewCell.kCellId, bundle: nil), forCellWithReuseIdentifier: ChannelCollectionViewCell.kCellId)
        collectionView.register(UINib(nibName: TVGuideCollectionViewCell.kCellId, bundle: nil), forCellWithReuseIdentifier: TVGuideCollectionViewCell.kCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        customCollectionViewLayout = CustomCollectionViewLayout()
        collectionView.collectionViewLayout = customCollectionViewLayout
        collectionView.addSubview(refreshControl)
        collectionView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)

        //load data
        tvGuidePresenter.attachView(view: self)
        tvGuidePresenter.getChannels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isLoadData {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        isLoadData = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        dicEvents.removeAll()
        tvGuidePresenter.getChannels()
    }

    func getCollectionView() -> UICollectionView? {
        if collectionView != nil {
            return collectionView
        }

        return nil
    }
}

extension TVGuideViewController: TVGuideView {

    func startLoading() {
        SVProgressHUD.show()
    }

    func startLoadingWithCustomAnimation() {
        SVProgressHUD.show()
    }

    func finishLoading() {
        isLoadMore = false
        SVProgressHUD.dismiss()
        refreshControl.endRefreshing()
    }

    func setChannels(channels: [Channel]?) {
        if let channelList = channels {
            self.channels = channelList
            customCollectionViewLayout.channels = self.channels
            tvGuidePresenter.loadSectionMore(self.channels)
            tvGuidePresenter.getEvents(self.channels, DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " 00:00", DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " 23:00")
        }
    }

    func setEvents(events: [Event]?) {
        if let eventList = events {
            for event in eventList {
                if let channelId = event.channelId {
                    if dicEvents[Int(channelId)] == nil {
                        let channelEvents = [Event]()
                        dicEvents[Int(channelId)] = channelEvents
                    }
                    dicEvents[Int(channelId)]?.append(event)
                }
            }
        }

        customCollectionViewLayout.dicEvents = dicEvents

        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.customCollectionViewLayout.dataSourceDidUpdate = true
        }
    }

    func setSearchChannels(channels: [Channel]?) {

    }
}

extension TVGuideViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tvGuidePresenter.getNumberOfSection() + 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return times.count + 1
        } else {

            if section - 1 < channels.count {
                if let channelId = channels[section - 1].channelId {
                    if dicEvents[Int(channelId)] != nil {
                        return dicEvents[Int(channelId)]?.count ?? 0
                    }
                }
            }

            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnNowCollectionViewCell.kCellId, for: indexPath) as! OnNowCollectionViewCell //swiftlint:disable:this force_cast
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCollectionViewCell.kCellId, for: indexPath) as! TimeCollectionViewCell //swiftlint:disable:this force_cast
                cell.bindingData(times[indexPath.row - 1])
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCollectionViewCell.kCellId, for: indexPath) as! ChannelCollectionViewCell //swiftlint:disable:this force_cast
                cell.bindingData(channels[indexPath.section - 1])
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVGuideCollectionViewCell.kCellId, for: indexPath) as! TVGuideCollectionViewCell //swiftlint:disable:this force_cast
                if indexPath.section - 1 < channels.count {
                    if let channelId = channels[indexPath.section - 1].channelId {
                        if let dic = dicEvents[Int(channelId)] {
                            cell.bindingData(dic[indexPath.row - 1])
                        }
                    }
                }

                return cell
            }
        }
    }

    //load more
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if tvGuidePresenter.isCanLoadMore(channels) {
            if offsetY > contentHeight - scrollView.frame.size.height && !isLoadMore {
                isLoadMore = true
                tvGuidePresenter.loadSectionMore(self.channels)
                tvGuidePresenter.getEvents(self.channels, DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " 00:00", DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " 23:00")
            }
        }
    }
}

extension TVGuideViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section != 0 && indexPath.row != 0 {

            if indexPath.section - 1 < channels.count {
                if let channelId = channels[indexPath.section - 1].channelId {
                    if let dic = dicEvents[Int(channelId)] {
                        let storyboard = UIStoryboard(name: "TVGuide", bundle: nil)
                        if let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController {
                            viewController.channel = channels[indexPath.section - 1]
                            viewController.event = dic[indexPath.row - 1]
                            navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                }
            }
        }
    }
}
