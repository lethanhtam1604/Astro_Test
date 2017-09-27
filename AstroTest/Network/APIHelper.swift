//
//  APIHelper.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class APIHelper {

    static func getChannels(completion: @escaping (_ response: Response, _ channels: [Channel]?) -> Void ) {

        APIRequest.request(request: Router.getChannels().asURLRequest()) { (error, data) in
            if let error = error {
                DispatchQueue.main.async {
                    print("error: \(error.localizedDescription)")
                    completion(Response(error.localizedDescription, false), nil)
                }
            } else {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]

                    var result: [Channel] = []

                    if let channels = json??["channel"] as? [[String: Any]] {
                        for channel in channels {
                            result.append(Channel(channel))
                        }
                    }
                    DispatchQueue.main.async {
                        completion(Response(), result)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(Response(), nil)
                    }
                }
            }
        }
    }

    static func getEvents(_ channelIds: [Int64], _ periodStart: String, _ periodEnd: String, completion: @escaping (_ response: Response, _ events: [Event]?) -> Void ) {

        APIRequest.request(request: Router.getEvents(channelIds, periodStart, periodEnd).asURLRequest()) { (error, data) in
            if let error = error {
                DispatchQueue.main.async {
                    print("error: \(error.localizedDescription)")
                    completion(Response(error.localizedDescription, false), nil)
                }
            } else {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                    var result: [Event] = []
                    if let events = json??["getevent"] as? [[String: Any]] {
                        for event in events {
                            let newEvent = Event(event)
                            result.append(newEvent)
                        }
                    }

                    DispatchQueue.main.async {
                        completion(Response(), result)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(Response(), nil)
                    }
                }
            }
        }
    }

    static func othersApiHere() {

    }
}
