//
//  SortChannelViewController.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/24/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

protocol SortChannelDelegate: class {
    func applySort()
}

class SortChannelViewController: BaseViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!

    fileprivate let channelSortTypes: [String] = ["Channel Numer", "Channel Name"]

    fileprivate var channelStatusIndex = 0
    open weak var delegate: SortChannelDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("sort", comment: "").uppercased()

        //setting navigation bar items
        let cancelBarButton = UIBarButtonItem(title: NSLocalizedString("cancel", comment: "").uppercased(), style: .done, target: self, action: #selector(actionTapToCancelBtn))
        cancelBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorMain, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15) ?? UIFont.systemFontSize], for: UIControlState.normal)
        navigationItem.leftBarButtonItem = cancelBarButton

        let applyBarButton = UIBarButtonItem(title: NSLocalizedString("apply", comment: "").uppercased(), style: .done, target: self, action: #selector(actionTapToApplyBtn))
        applyBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorMain, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15) ?? UIFont.systemFontSize], for: UIControlState.normal)
        navigationItem.rightBarButtonItem = applyBarButton

        //setup tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SortTableViewCell.kCellId, bundle: nil), forCellReuseIdentifier: SortTableViewCell.kCellId)
        tableView.register(UINib(nibName: SortHeaderTableViewCell.kCellId, bundle: nil), forCellReuseIdentifier: SortHeaderTableViewCell.kCellId)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = Global.colorSeparator

        //set Data
        channelStatusIndex = UserDefaultManager.getInstance().getChannelStatusSort()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func actionTapToCancelBtn() {
        dismiss(animated: true, completion: nil)
    }

    func actionTapToApplyBtn() {
        UserDefaultManager.getInstance().setChannelStatusSort(value: channelStatusIndex)
        delegate?.applySort()
        dismiss(animated: true, completion: nil)
    }
}

extension SortChannelViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelSortTypes.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortHeaderTableViewCell.kCellId) as! SortHeaderTableViewCell //swiftlint:disable:this force_cast

        return cell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortTableViewCell.kCellId, for: indexPath) as! SortTableViewCell //swiftlint:disable:this force_cast
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero

        if indexPath.row == channelStatusIndex {
            cell.bindingData(true, channelSortTypes[indexPath.row])
        } else {
            cell.bindingData(false, channelSortTypes[indexPath.row])
        }

        return cell
    }
}

extension SortChannelViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortTableViewCell.kCellId) as! SortTableViewCell  //swiftlint:disable:this force_cast
        cell.bindingDataHeightForCell(channelSortTypes[indexPath.row])

        return cell.heightForCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let previousCell = tableView.cellForRow(at: NSIndexPath(item: channelStatusIndex, section: 0) as IndexPath) as? SortTableViewCell {
            previousCell.unCheckmarkCell()
        }

        let currentCell = tableView.cellForRow(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath) as! SortTableViewCell //swiftlint:disable:this force_cast
        currentCell.checkmarkCell()

        channelStatusIndex = indexPath.row
    }
}
