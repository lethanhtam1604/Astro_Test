//
//  UIImageView.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/23/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImagesUsingUrlString(urlString: String) {
        let url = URL(string: urlString)

        image = nil

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }

        if let newURL = url {
            URLSession.shared.dataTask(with: newURL) { (data, _, error) in

                if error != nil {
                    print(error ?? "")
                    return
                }

                DispatchQueue.main.async {
                    if let newData = data {
                        if let imageToCache = UIImage(data: newData) {
                            imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                            self.image = imageToCache
                        }
                    }
                }
            }.resume()
        }
    }
}
