//
//  DateUtil.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/27/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class DateUtil: NSObject {

    enum DateFormat: String {
        case yyyymmdd = "yyyy-MM-dd"
        case yyyymmddhhmm = "yyyy-MM-dd HH:mm"
        case yyyymmddhhmmss = "yyyy-MM-dd HH:mm:ss"
        case yyyymmddhhmmssS = "yyyy-MM-dd HH:mm:ss.S"
        case hhmmss = "HH:mm:ss"
        case hhmm = "HH:mm"
        case hhmma = "HH:mm a"
    }

    private static let kDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.ReferenceType.local
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static func string(_ date: Date = Date(), format: DateFormat = .yyyymmddhhmmssS) -> String {
        kDateFormatter.dateFormat = format.rawValue
        return kDateFormatter.string(from: date)
    }

    static func stringTime(_ dateString: String = DateUtil.string(), format: DateFormat = .yyyymmddhhmmssS) -> String {
        kDateFormatter.dateFormat = format.rawValue
        guard let date = kDateFormatter.date(from: dateString) else {
            return ""
        }
        return string(date, format: DateFormat.hhmma)
    }

    static func time(_ dateString: String = DateUtil.string(), format: DateFormat = .yyyymmddhhmmssS) -> String {
        kDateFormatter.dateFormat = format.rawValue
        guard let date = kDateFormatter.date(from: dateString) else {
            return ""
        }
        return string(date, format: DateFormat.hhmmss)
    }

    static func minutes(_ earlierDate: String = DateUtil.string(), _ laterDate: String = DateUtil.string(), format: DateFormat = .yyyymmddhhmmssS) -> Int {
        kDateFormatter.dateFormat = format.rawValue
        guard let dateEarlier = kDateFormatter.date(from: earlierDate) else {
            return 0
        }
        guard let dateLater = kDateFormatter.date(from: laterDate) else {
            return 0
        }

        let interval = dateLater.timeIntervalSince(dateEarlier)
        let ti = NSInteger(interval)
        let minutes = ti / 60
        return minutes
    }

    static func minutesFromDate(_ dateString: String = DateUtil.string(), format: DateFormat = .yyyymmddhhmmssS) -> Int {
        kDateFormatter.dateFormat = format.rawValue
        guard let date = kDateFormatter.date(from: dateString) else {
            return 0
        }

        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return hours * 60 + minutes
    }
}
