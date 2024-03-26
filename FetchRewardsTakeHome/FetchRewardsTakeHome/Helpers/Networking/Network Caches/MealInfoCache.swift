//
//  MealInfoCache.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/25/24.
//

import Foundation
import SwiftUI

typealias MealInfoCache = LocalNetworkCache<MealInfo>

struct MealInfoCacheKey: EnvironmentKey {
  static let defaultValue = MealInfoCache()
}

extension EnvironmentValues {
  var mealInfoCache: MealInfoCache {
    get { self[MealInfoCacheKey.self] }
    set { self[MealInfoCacheKey.self] = newValue }
  }
}
