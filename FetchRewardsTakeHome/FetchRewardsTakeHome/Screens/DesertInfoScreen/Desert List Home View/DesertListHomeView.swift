//
//  DesertListHomeView.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/19/24.
//

import SwiftUI

struct DesertListHomeView: View {

  @StateObject var viewModel: DesertListHomeViewViewModel

    var body: some View {
      NavigationStack {
        ZStack {
          if viewModel.viewState == .loading {
            ProgressView()
          }
          desertList
        } // End ZStack
        .onAppear(perform: viewModel.fetchDeserts)
        /// How to refactor this to be smaller?
        .alert($viewModel.alert.wrappedValue?.title ?? "Alert",
               isPresented: Binding(get: { viewModel.hasAlert },
                                    set: { viewModel.hasAlert = $0 }),
               actions: {
          Button(action: viewModel.fetchDeserts) {
            Text("Retry")
          }
        },
        message: {
          if let alert = viewModel.alert,
             let subTitle = alert.subTitle {
            Text(subTitle)
          }
        })
      } // End NavigationStack
      .refreshable { viewModel.fetchDeserts() }
    }

  private var desertList: some View {
    List {
      ForEach(viewModel.deserts, id: \.mealID) { desert in
        NavigationLink(destination: DesertInfoScreen(viewModel: DesertInfoScreenViewModel(mealID: desert.mealID))) {
          HStack {
            AsyncImage(url: desert.thumbnailURL,
                       image: { Image(uiImage: $0) })
            .frame(width: 40, height: 40)
            Text(desert.name)
            Spacer()
          }
        }
      }
    }
    .navigationTitle("Deserts")
  }
}

#Preview {
  DesertListHomeView(viewModel: DesertListHomeViewViewModel())
}
