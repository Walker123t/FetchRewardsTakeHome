//
//  AsyncImage.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/20/24.
//

import SwiftUI

struct AsyncImage: View {
  @StateObject private var loader: ImageLoader
  @Environment(\.imageCache) var imageCache
  private let image: (UIImage) -> Image

  init(url: URL,
       @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
    self.image = image
    _loader = StateObject(wrappedValue: ImageLoader(url: url))
  }

  var body: some View {
    content
      .onAppear {
        loader.setCache(imageCache)
        loader.load()
      }
  }

  private var content: some View {
    Group {
      if let loaderImage = loader.image {
        image(loaderImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
      } else {
        ProgressView()
      }
    }
  }
}
