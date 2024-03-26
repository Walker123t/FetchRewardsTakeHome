//
//  DesertInfoScreenViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/25/24.
//

import Foundation
import Combine

class DesertInfoScreenViewModel: ObservableObject {
  enum DesertInfoScreenState {
    case loading
    case loaded(MealInfo)
    case alert
  }

  private let mealID: String
  private var cancellables = Set<AnyCancellable>()
  private var cache: MealInfoCache?

  @Published var viewState: DesertInfoScreenState = .loading
  @Published var hasAlert: Bool = false
  @Published var alert: NetworkErrorAlert? = nil

  init(mealID: String) {
    self.mealID = mealID
  }

  func setCache(_ cache: MealInfoCache) {
    self.cache = cache
  }

  func fetchDeserts() {
    if let url = EndPoint.getMealDetails(id: mealID).url,
      let desert = cache?[url] {
      self.viewState = .loaded(desert)
      return
    }
    self.hasAlert = false
    self.alert = nil
    viewState = .loading
    NetworkController.fetchMealDetails(for: mealID)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { alert in
        guard case let .failure(alert) = alert else { return }
        self.viewState = .alert
        self.hasAlert = true
        self.alert = alert

      }, receiveValue: { desert in
        self.viewState = .loaded(desert)
        self.cache?[EndPoint.getMealDetails(id: self.mealID).url!] = desert
      })
      .store(in: &cancellables)
  }
}
