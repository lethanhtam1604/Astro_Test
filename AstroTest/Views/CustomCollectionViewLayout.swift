//
//  CustomCollectionViewLayout.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/25/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {

    fileprivate var CELL_HEIGHT = 100.0
    fileprivate var CELL_WIDTH = 150.0
    fileprivate let STATUS_BAR = UIApplication.shared.statusBarFrame.height
    fileprivate var cellAttrsDictionary: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    fileprivate var contentSize = CGSize.zero
    var dataSourceDidUpdate = true

    var channels: [Channel] = []
    var dicEvents: [Int: [Event]] = [:]

    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }

    override func prepare() {
        if !dataSourceDidUpdate {
            let xOffset = collectionView?.contentOffset.x ?? 0
            let yOffset = collectionView?.contentOffset.y ?? 0

            if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
                for section in 0...sectionCount - 1 {

                    if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                        if section == 0 {
                            for item in 0...rowCount - 1 {
                                let indexPath = IndexPath(item: item, section: section)

                                if let attrs = cellAttrsDictionary[indexPath] {
                                    var frame = attrs.frame
                                    if item == 0 {
                                        frame.origin.x = xOffset
                                    }

                                    frame.origin.y = yOffset
                                    attrs.frame = frame
                                }
                            }
                        } else {
                            let indexPath = IndexPath(item: 0, section: section)

                            if let attrs = cellAttrsDictionary[indexPath] {
                                var frame = attrs.frame
                                frame.origin.x = xOffset
                                attrs.frame = frame
                            }
                        }
                    }
                }
            }
            return
        }

        dataSourceDidUpdate = false

        if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
            for section in 0...sectionCount - 1 {
                if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {

                    var earlierTime = ""
                    var laterTime = ""
                    var durationTime = ""

                    for item in 0...rowCount - 1 {

                        let cellIndex = IndexPath(item: item, section: section)
                        var calculatedCellWidth: Double
                        var xPos: Double
                        var yPos: Double = 0.0

                        if section == 0 {
                            CELL_HEIGHT = 60

                            if item == 0 {
                                CELL_WIDTH = 120
                                xPos = Double(item) * CELL_WIDTH
                            } else {
                                calculatedCellWidth = CELL_WIDTH
                                CELL_WIDTH = 200
                                xPos = 120 + Double(item - 1) * calculatedCellWidth
                            }

                        } else {
                            CELL_HEIGHT = 100

                            if item == 0 {
                                CELL_WIDTH = 120
                                xPos = Double(item) * CELL_WIDTH
                                
                                earlierTime = DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " 00:00:00.0"

                            } else {

                                var event: Event?

                                if section - 1 < channels.count {
                                    if let channelId = channels[section - 1].channelId {
                                        if let dic = dicEvents[Int(channelId)] {
                                            event = dic[item - 1]
                                        }
                                    }
                                }

                                if let displayDateTime = event?.displayDateTime {
                                    laterTime = displayDateTime
                                }

                                if let displayDuration = event?.displayDuration {
                                    durationTime = DateUtil.string(format: DateUtil.DateFormat.yyyymmdd) + " " + displayDuration + ".0"
                                }
                                
                                let ealierMinutes = DateUtil.minutes(earlierTime, laterTime, format: DateUtil.DateFormat.yyyymmddhhmmssS)
                                let laterMinutes = DateUtil.minutesFromDate(durationTime, format: DateUtil.DateFormat.yyyymmddhhmmssS)

                                CELL_WIDTH = Double((laterMinutes * 200) / 60)
                                xPos = Double(120 + 100 + (ealierMinutes * 200) / 60)
                            }

                            yPos = 60 + Double(section - 1) * CELL_HEIGHT
                        }

                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)

                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        cellAttrsDictionary[cellIndex] = cellAttributes
                    }
                }
            }
        }

        let contentWidth = Double(collectionView?.numberOfItems(inSection: 0) ?? 0) * 200
        let contentHeight = Double(collectionView?.numberOfSections ?? 0) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var attributesInRect = [UICollectionViewLayoutAttributes]()

        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        return attributesInRect
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
