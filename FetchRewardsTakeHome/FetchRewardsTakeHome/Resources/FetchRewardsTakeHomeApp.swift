//
//  FetchRewardsTakeHomeApp.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/19/24.
//

import SwiftUI

@main
struct FetchRewardsTakeHomeApp: App {
    var body: some Scene {
        WindowGroup {
          DesertListHomeView(viewModel: DesertListHomeViewViewModel())
            .preferredColorScheme(.light)
        }
    }
}
