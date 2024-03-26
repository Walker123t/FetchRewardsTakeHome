//
//  TopLevelNetworkingResponse.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/25/24.
//

import Foundation

struct TopLevelNetworkResponse<T: Decodable>: Decodable {
  let meals: T
}
