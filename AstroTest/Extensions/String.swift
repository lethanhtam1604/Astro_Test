//
//  String.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/27/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

extension String {

    func addingPercentEncodingForURLQueryValue() -> String? {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return addingPercentEncoding(withAllowedCharacters: allowed)
    }
}
