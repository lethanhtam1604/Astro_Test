//
//  APIRequest.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class APIRequest: NSObject {

    private static func dataTask(request: URLRequest, completion: @escaping (_ error: Error?, _ data: Data?) -> ()) {

        let session = URLSession(configuration: URLSessionConfiguration.default)

        session.dataTask(with: request) { (data, _, error) -> Void in
            completion(error, data)
        }.resume()
    }

    static func request(request: URLRequest, completion: @escaping (_ error: Error?, _ data: Data?) -> ()) {
        dataTask(request: request, completion: completion)
    }
}
