//
//  Time.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/26/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

class Time: NSObject {

    var value: Int = 0
    var type: Bool = false

    override init() {
        
    }

    init(_ value: Int, _ type: Bool) {
        self.value = value
        self.type = type
    }
}
