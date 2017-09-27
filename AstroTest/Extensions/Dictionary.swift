//
//  Dictionary.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/27/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

extension Dictionary {

    func stringFromHttpParameters() -> String {
        let parameterArray = map { key, value -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()! //swiftlint:disable:this force_cast //swiftlint:disable:this force_unwrapping
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()! //swiftlint:disable:this force_cast //swiftlint:disable:this force_unwrapping
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }

        return parameterArray.joined(separator: "&")
    }
}
