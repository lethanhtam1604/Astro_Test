//
//  TVGuideViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class TVGuideViewController: BaseViewController {

    @IBOutlet fileprivate weak var onNowButton: UIButton!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var indicator: UIActivityIndicatorView!

    fileprivate var customCollectionViewLayout: CustomCollectionViewLayout!
    fileprivate let tvGuidePresenter = TVGuidePresenter()
    fileprivate var channels: [Channel] = []
    fileprivate var times: [Time] = TimeManager.getInstance().getTimes()
    fileprivate var isLoadMore = true
    fileprivate var events: [[Event]] = [[]]
    fileprivate var dicEvents: [Int: [Event]] = [:]
    fileprivate var isLoadData = false
    fileprivate var isRefreshChannel = true

    fileprivate var timer: Timer!
    fileprivate let currentLineView = UIView()
    fileprivate let lineView = UIView()
    fileprivate let onNowBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("tv_guide", comment: "").uppercased()

        //setting navigation bar items
        let sortBarButton = UIBarButtonItem(image: UIImage(named: "ic_sort"), style: .done, target: self, action: #selector(actionTapToSortBtn))
        navigationItem.leftBarButtonItem = sortBarButton

        let todayBarButton = UIBarButtonItem(title: NSLocalizedString("Today", comment: ""), style: .done, target: self, action: #selector(actionTapToTodayButton))
        todayBarButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Global.colorMain, NSAttributedStringKey.font: UIFont(name: "OpenSans-semibold", size: 15) ?? UIFont.systemFontSize], for: UIControlState.normal)
        navigationItem.rightBarButtonItem = todayBarButton

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

        //setting UI
        onNowButton.layer.cornerRadius = 5

        currentLineView.backgroundColor = UIColor.clear
        currentLineView.frame = CGRect(x: self.customCollectionViewLayout.getXPosForCurrentTime(), y: 0, width: 0, height: self.customCollectionViewLayout.getHeight())

        lineView.frame = CGRect(x: currentLineView.frame.width / 2, y: currentLineView.frame.origin.y, width: 2, height: currentLineView.frame.height)
        lineView.backgroundColor = Global.colorMain

        onNowBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        onNowBtn.backgroundColor = UIColor.clear
        onNowBtn.layer.borderColor = Global.colorMain.cgColor
        onNowBtn.layer.borderWidth = 1
        onNowBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 12) ?? UIFont.systemFont(ofSize: 12)
        onNowBtn.setTitle(NSLocalizedString("on_now", comment: ""), for: .normal)
        onNowBtn.setTitleColor(Global.colorMain, for: .normal)

        currentLineView.addSubview(lineView)
        currentLineView.addSubview(onNowBtn)
        collectionView.addSubview(currentLineView)

        //load data
        tvGuidePresenter.attachView(view: self)
        tvGuidePresenter.getChannels()

        //Timer
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateXPosForCurrentTime), userInfo: self, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !Global.isUpdateTVGuideBySorting {
            Global.isUpdateTVGuideBySorting = true
            applySort()
        }

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

    @objc func actionTapToSortBtn() {
        let storyboard = UIStoryboard(name: "Channels", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "SortChannelViewController") as? SortChannelViewController {
            viewController.delegate = self
            let nav = UINavigationController(rootViewController: viewController)
            present(nav, animated: true, completion: nil)
        }
    }

    @IBAction func actionTapToOnNowBtn(_ sender: Any) {
        updateCollectionViewForCurrentTime()
    }

    @objc func actionTapToTodayButton() {

    }
}

extension TVGuideViewController: SortChannelDelegate {

    func applySort() {
        Global.isUpdateChannelsBySorting = false
        onNowButton.isHidden = true
        currentLineView.isHidden = true
        customCollectionViewLayout.cellAttrsDictionary = [:]
        isRefreshChannel = true
        tvGuidePresenter.sortChannels(channels)
    }
}

extension TVGuideViewController: TVGuideView {

    func startLoading() {
        indicator.startAnimating()
    }

    func finishLoading() {

    }

    func setChannels(channels: [Channel]?) {
        if let channelList = channels {
            self.channels = channelList
            customCollectionViewLayout.channels = self.channels
            tvGuidePresenter.initializeSection(self.channels)
            tvGuidePresenter.getEvents(self.channels, DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " 00:00", DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " 23:00")
        }
    }

    func setEvents(events: [Event]?) {

        if isRefreshChannel {
            isRefreshChannel = false
            dicEvents = [:]
        }

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
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.customCollectionViewLayout.dataSourceDidUpdate = true
            self.updateCollectionViewForCurrentTime()
            self.updateXPosForCurrentTime()
            self.isLoadMore = false
            self.currentLineView.isHidden = false
            self.onNowButton.isHidden = false
            self.indicator.stopAnimating()
        }
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

extension TVGuideViewController {

    func updateCollectionViewForCurrentTime() {
        let indexPath = NSIndexPath(row: customCollectionViewLayout.getRowForCurrentTime(), section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: false)

        let cellSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRect(x: customCollectionViewLayout.getXPosForCurrentTime() - view.frame.width / 2, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    }

    func getCollectionView() -> UICollectionView? {
        if collectionView != nil {
            return collectionView
        }

        return nil
    }

    @objc func updateXPosForCurrentTime() {
        self.currentLineView.frame = CGRect(x: self.customCollectionViewLayout.getXPosForCurrentTime() - 25, y: 60 - 20, width: 0, height: self.customCollectionViewLayout.getHeight())
        self.lineView.frame = CGRect(x: 25, y: self.currentLineView.frame.origin.y - 20, width: 2, height: self.currentLineView.frame.height)

        self.collectionView.reloadData()
    }
}
