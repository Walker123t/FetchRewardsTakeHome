//
//  Image Cache.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/20/24.
//

import UIKit
import SwiftUI

typealias ImageCache = LocalNetworkCache<UIImage>

struct ImageCacheKey: EnvironmentKey {
  static let defaultValue = ImageCache()
}

extension EnvironmentValues {
  var imageCache: ImageCache {
    get { self[ImageCacheKey.self] }
    set { self[ImageCacheKey.self] = newValue }
  }
}
