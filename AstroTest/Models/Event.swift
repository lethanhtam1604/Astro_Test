//
//  Event.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/27/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class Event: NSObject {

    var channelId: Int64?
    var eventID: String?
    var programmeTitle: String?
    var programmeId: String?
    var shortSynopsis: String?
    var displayDateTimeUtc: String?
    var displayDateTime: String?
    var displayDuration: String?

    override init() {
        
    }

    init(_ event: [String : Any]) {
        channelId = event["channelId"] as? Int64
        eventID = event["eventID"] as? String
        programmeTitle = event["programmeTitle"] as? String
        programmeId = event["programmeId"] as? String
        shortSynopsis = event["shortSynopsis"] as? String
        displayDateTimeUtc = event["displayDateTimeUtc"] as? String
        displayDateTime = event["displayDateTime"] as? String
        displayDuration = event["displayDuration"] as? String
    }
}
