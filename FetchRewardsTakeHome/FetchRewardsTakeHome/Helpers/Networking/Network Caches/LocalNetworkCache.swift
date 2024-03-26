//
//  LocalNetworkCache.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/25/24.
//

import Foundation
import UIKit.UIImage

struct LocalNetworkCache<T: AnyObject> {
  private let cache: NSCache = NSCache<NSURL, T>()

  subscript(_ key: URL) -> T? {
    get { cache.object(forKey: key as NSURL) }
    set {
      guard let newValue = newValue else { cache.removeObject(forKey: key as NSURL); return }
      cache.setObject(newValue, forKey: key as NSURL)
    }
  }
}
