//
//  Meal.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/20/24.
//

import Foundation

enum MealType: String {
  case desert = "Dessert"
}

struct Meal: Decodable {
  let name: String
  private let thumbURLString: String
  let mealID: String

  var thumbnailURL: URL {
    return URL(string: thumbURLString)!
  }

  enum CodingKeys: String, CodingKey {
    case name = "strMeal"
    case thumbURLString = "strMealThumb"
    case mealID = "idMeal"
  }
}
