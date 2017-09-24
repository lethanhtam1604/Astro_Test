//
//  DatabaseHelper.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit
import CoreData

class DatabaseHelper: NSObject {

    private static var instance: DatabaseHelper!

    static func getInstance() -> DatabaseHelper {
        if instance == nil {
            instance = DatabaseHelper()
        }

        return instance
    }

    private override init() {
        super.init()

    }
}
