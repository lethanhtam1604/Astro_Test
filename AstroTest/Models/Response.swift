//
//  Response.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class Response {

    let message: String
    let success: Bool

    init(_ message: String = "", _ success: Bool = true) {
        self.message = message
        self.success = success
    }
}
