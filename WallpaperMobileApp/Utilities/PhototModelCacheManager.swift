//
//  PhototModelCacheManager.swift
//  WallpaperMobileApp
//
//  Created by Denys Nikolaichuk on 02.05.2023.
//

import Foundation
import SwiftUI

class PhotoModelCacheManager {
    static let instance = PhotoModelCacheManager()
  
    var photoCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 200 // 200mb
        return cache
    }()
    
    private init() {}
    
    func add(image: UIImage, name: String) {
        photoCache.setObject(image, forKey: name as NSString)
    }
    
    func get(name: String) -> UIImage? {
        return photoCache.object(forKey: name as NSString)
    }
}
