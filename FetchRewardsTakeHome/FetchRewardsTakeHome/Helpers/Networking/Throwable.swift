//
//  Throwable.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/20/24.
//

import Foundation

enum Throwable<T: Decodable>: Decodable {
  case success(T)
  case failure(Error)

  init(from decoder: Decoder) throws {
    do {
      let decoded = try T(from: decoder)
      self = .success(decoded)
    } catch let error {
      self = .failure(error)
    }
  }

  var value: T? {
    switch self {
    case .failure(_):
      return nil
    case .success(let value):
      return value
    }
  }
}
