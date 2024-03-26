//
//  DesertListHomeViewModel.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/20/24.
//

import Foundation
import Combine

class DesertListHomeViewViewModel: ObservableObject {

  enum DesertListHomeViewState {
    case loading
    case loaded
  }

  private var cancellables = Set<AnyCancellable>()
  @Published var deserts: [Meal] = []
  @Published var viewState: DesertListHomeViewState = .loading
  @Published var hasAlert: Bool = false
  @Published var alert: NetworkErrorAlert? = nil

  func fetchDeserts() {
    self.hasAlert = false
    self.alert = nil
    viewState = .loading
    NetworkController.fetchMeals(type: .desert)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { alert in
        self.viewState = .loaded

        guard case let .failure(alert) = alert else { return }
        self.hasAlert = true
        self.alert = alert

      }, receiveValue: { deserts in
        self.deserts = deserts
        self.viewState = .loaded
      })
      .store(in: &cancellables)
  }
}
