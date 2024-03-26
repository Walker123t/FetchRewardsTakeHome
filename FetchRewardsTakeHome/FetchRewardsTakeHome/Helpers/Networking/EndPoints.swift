//
//  EndPoints.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/25/24.
//

import Foundation

enum EndPoint {

  case getMeals(for: MealType)
  case getMealDetails(id: String)

  private var scheme: String {
    return "https"
  }

  private var host: String {
    return "www.themealdb.com"
  }

  private var path: String {
    switch self {
    case .getMeals:
      return "/api/json/v1/1/filter.php"
    case .getMealDetails:
      return "/api/json/v1/1/lookup.php"
    }
  }

  private var queryItems: [URLQueryItem] {
    switch self {
    case .getMeals(let category):
      return [URLQueryItem(name: "c", value: category.rawValue)]
    case .getMealDetails(id: let id):
      return [URLQueryItem(name: "i", value: id)]
    }
  }

  var url: URL? {
    var urlComponent = URLComponents()
    urlComponent.host = host
    urlComponent.scheme = scheme
    urlComponent.path = path
    urlComponent.queryItems = queryItems
    return urlComponent.url
  }
}
