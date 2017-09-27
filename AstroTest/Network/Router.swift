//
//  Router.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import Foundation

enum Router {

    static let host = "ams-api.astro.com.my"
    static let baseURLString = "http://\(Router.host)"

    case getChannels()
    case getEvents([Int64], String, String)

    var method: String {
        switch self {
        case .getChannels:
            return "GET"
        case .getEvents:
            return "GET"
        }
    }

    var path: String {
        switch self {
        case .getChannels:
            return "/ams/v3/getChannels"
        case .getEvents:
            return "/ams/v3/getEvents"
        }
    }

    var contentType: String {
        switch self {
        case .getChannels:
            return "application/json"
        case .getEvents:
            return "application/json"
        }
    }

    func asURLRequest() -> URLRequest {

        switch self {
        case .getChannels:
            let url = URL(string: Router.baseURLString)
            var urlRequest = URLRequest(url: (url?.appendingPathComponent(path))!) //swiftlint:disable:this force_unwrapping
            urlRequest.httpMethod = method
            return urlRequest
        case .getEvents(let channelIds, let periodStart, let periodEnd):

            var pathString = ""
            if !channelIds.isEmpty {
                for index in 0..<channelIds.count - 1 {
                    pathString += String(channelIds[index]) + ","
                }
                pathString += String(channelIds[channelIds.count - 1])
            }

            let parameters: [String: AnyObject] = ["channelId": pathString as AnyObject, "periodStart": periodStart as AnyObject, "periodEnd": periodEnd as AnyObject]

            let parameterString = parameters.stringFromHttpParameters()
            let requestURL = URL(string: Router.baseURLString + path + "?" + parameterString)! //swiftlint:disable:this force_unwrapping

            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = method

            return urlRequest
        }
    }
}
