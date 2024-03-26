//
//  NetworkController.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/19/24.
//

import Combine
import Foundation

enum NetworkErrorAlert: Error, LocalizedError {
  case invalidURL
  case networkError(Error)
  case noData
  case unableToDecode
  case error(Error)

  // Alert Text
  var title: String {
    switch self {
    case .invalidURL:
      return "InvalidURL"
    case .noData:
      return "No Data Found"
    case .unableToDecode:
      return "Unable to Decode Data"
    case .networkError:
      return "Network Error"
    case .error:
      return "Error"
    }
  }

  var subTitle: String? {
    switch self {
    case .invalidURL:
      return "Please contact us"
    case .noData, .unableToDecode:
      return nil
    case .networkError(let error), .error(let error):
      return "error: \(error.localizedDescription)"
    }
  }
}

struct NetworkController {

  static func fetchMeals(type: MealType) -> AnyPublisher<[Meal], NetworkErrorAlert> {
    guard let url = EndPoint.getMeals(for: type).url else {
      return Fail(error: NetworkErrorAlert.invalidURL)
        .eraseToAnyPublisher()
    }

    return URLSession.shared.dataTaskPublisher(for: url)
      .mapError({ error in NetworkErrorAlert.networkError(error) })
      .map(\.data)
      .decode(type: TopLevelNetworkResponse<[Throwable<Meal>]>.self, decoder: JSONDecoder())
      .mapError({ error in NetworkErrorAlert.unableToDecode })
      .map({ $0.meals.compactMap({ $0.value })
        .filter({ !$0.name.isEmpty })
        .sorted(by: {$0.name.lowercased() < $1.name.lowercased()}) })
      .mapError({ _ in NetworkErrorAlert.noData })
      .eraseToAnyPublisher()
  }

  static func fetchMealDetails(for mealID: String) -> AnyPublisher<MealInfo, NetworkErrorAlert> {
    guard let url = EndPoint.getMealDetails(id: mealID).url else {
      return Fail(error: NetworkErrorAlert.invalidURL)
        .eraseToAnyPublisher()
    }

    return URLSession.shared.dataTaskPublisher(for: url)
      .mapError({ error in NetworkErrorAlert.networkError(error) })
      .map(\.data)
      .decode(type: TopLevelNetworkResponse<[MealDetailNetworkResponse]>.self, decoder: JSONDecoder())
      .map {
        MealInfo(from: $0.meals[0])
      }
      .mapError({
        error in .unableToDecode
      })
      .eraseToAnyPublisher()
  }
}
