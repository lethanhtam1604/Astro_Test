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

    var method: String {
        switch self {
        case .getChannels:
            return "GET"
        }
    }

    var path: String {
        switch self {
        case .getChannels:
            return "/ams/v3/getChannels"
        }
    }

    var contentType: String {
        switch self {
        case .getChannels:
            return "application/json"
        }
    }

    func asURLRequest() -> URLRequest {
        let url = URL(string: Router.baseURLString)
        var urlRequest = URLRequest(url: (url?.appendingPathComponent(path))!) //swiftlint:disable:this force_unwrapping
        urlRequest.httpMethod = method

        var _ : [String: Any] = [:]

        switch self {
        case .getChannels:
            return urlRequest
        }
    }
}
