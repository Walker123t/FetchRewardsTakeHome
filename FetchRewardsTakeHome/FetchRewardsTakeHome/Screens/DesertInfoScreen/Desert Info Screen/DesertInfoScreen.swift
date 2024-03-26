//
//  DesertInfoScreen.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/21/24.
//

import SwiftUI

struct DesertInfoScreen: View {
  @StateObject var viewModel: DesertInfoScreenViewModel
  @Environment(\.dismiss) var dismiss
  @Environment(\.mealInfoCache) var mealInfoCache

    var body: some View {
      ZStack {
        switch viewModel.viewState {
        case .loading, .alert:
          ProgressView()
        case .loaded(let desert):
          contentList(desert: desert)
        }
      }
      .onAppear{
        viewModel.setCache(mealInfoCache)
        viewModel.fetchDeserts()
      }
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
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(action: { dismiss() }) {
            Image(systemName: "arrow.backward")
              .tint(.red)
          }
        }
      }
      .toolbarBackground(Color.white, for: .navigationBar)
    }

  private func contentList(desert: MealInfo) -> some View {
    ScrollView {
      VStack(spacing: 16) {
        topContent(desert: desert)
        ingredientList(desert.ingredients)
        instructions(desert.instructions)
      }
    }
    .navigationTitle(desert.name)
    .background(UIColor.systemGroupedBackground.asColor())
  }

  private func topContent(desert: MealInfo) -> some View {
    VStack {
      AsyncImage(url: desert.thumbnailURL)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding([.top, .horizontal], 16)
        .padding(.bottom, 28)

      Text(desert.name)
        .font(.system(.title))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
    .background(.white)
  }

  private func ingredientList(_ ingredients: [Ingredient]) -> some View {
    VStack(spacing: 0) {
      Text("Ingredients")
        .font(.system(.title2))
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      Divider()
      ForEach(ingredients) { ingredient in
        HStack {
          Text(ingredient.name)
          Spacer()
          Text(ingredient.quantity)
        }
        .padding(8)
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity)
        Divider()
          .padding(.horizontal)
      }
    }
    .background(.white)
  }

  private func instructions(_ instructions: String) -> some View {
    VStack {
      Text("Instructions")
        .font(.system(.title2))
        .padding([.top, .horizontal])
        .frame(maxWidth: .infinity, alignment: .leading)
      Divider()
      Text(instructions)
        .padding()
        .background(.white)
    }
    .background(.white)
  }
}

#Preview {
  DesertInfoScreen(viewModel: DesertInfoScreenViewModel(mealID: "53049"))
}
