//
//  ImageCache.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-27.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

protocol ImageCacheProtocol: class {
    func set(image: UIImage?, forURL: URL, completion: @escaping () -> Void)
    func getImage(forURL: URL, completion: @escaping (_ image: UIImage?) -> Void)
}

final class SimpleImageCache: ImageCacheProtocol {
    private var cache: NSCache<NSURL, UIImage>

    init() {
        self.cache = NSCache<NSURL, UIImage>()
        self.cache.countLimit = 40
        self.cache.totalCostLimit = 40_000_000
    }

    func set(image: UIImage?, forURL url: URL, completion: @escaping () -> Void) {
        if let image = image {
            self.cache.setObject(image, forKey: url as NSURL, cost: image.cacheCost)
        } else {
            self.cache.removeObject(forKey: url as NSURL)
        }

        completion()
    }

    func getImage(forURL url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        let cachedImage = self.cache.object(forKey: url as NSURL)
        completion(cachedImage)
    }
}

extension UIImage {
    fileprivate var cacheCost: Int {
        return Int(self.size.width * self.size.height * self.scale)
    }
}
