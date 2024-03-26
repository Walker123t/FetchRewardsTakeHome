//
//  ImageLoader.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/20/24.
//

import UIKit.UIImage
import Combine

class ImageLoader: ObservableObject {
  @Published var image: UIImage?
  private let url: URL
  private var cancellable: AnyCancellable?
  private var cache: ImageCache?
  private(set) var isLoading = false
  private static let imageLoadingQueue = DispatchQueue(label: "image-loading")

  init(url: URL) {
    self.url = url
  }

  deinit { cancellable?.cancel() }

  func setCache(_ imageCache: ImageCache) {
    self.cache = imageCache
  }

  func load() {
    guard !isLoading else { return }

    if let image = cache?[url] {
      self.image = image
      return
    }

    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: Self.imageLoadingQueue)
      .map { UIImage(data: $0.data) }
      .replaceError(with: nil)
      .handleEvents(receiveSubscription: { [weak self] _ in self?.isLoading = true },
                    receiveOutput: { [weak self] in
        guard let strongSelf = self else { return }
        $0.map {
          strongSelf.cache?[strongSelf.url] = $0
        }
      },
                    receiveCompletion: { [weak self] _ in self?.isLoading = false },
                    receiveCancel: { [weak self] in self?.isLoading = false })
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] in self?.image = $0 })
  }
}
