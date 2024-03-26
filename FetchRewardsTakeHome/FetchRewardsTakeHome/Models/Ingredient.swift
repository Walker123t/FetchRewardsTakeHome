//
//  Ingredient.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/25/24.
//

import Foundation

struct Ingredient: Identifiable {
  let name: String
  let quantity: String

  var id = UUID()
}
