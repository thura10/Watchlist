//
//  AsyncImage.swift
//  Watchlist
//
//  Created by Thura Soe Win on 27/5/21.
//

import Foundation
import SwiftUI
import Combine

#if os(macOS)
typealias UIImage = NSImage

extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}
#endif

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    
    private let url: URL?
    private var cancellable: AnyCancellable?
    
    private var cache: ImageCache?

    init(url: URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    deinit {
        cancel()
    }
    
    func load() {
        guard let url = url else {
            return
        }
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
           .map { UIImage(data: $0.data) }
           .replaceError(with: nil)
           .handleEvents(receiveOutput: { [weak self] in self?.cache($0) })
           .receive(on: DispatchQueue.main)
           .sink { [weak self] in self?.image = $0 }
    }

    func cancel() {
        cancellable?.cancel()
    }
    
    private func cache(_ image: UIImage?) {
        guard let url = url else {
            return
        }
        image.map { cache?[url] = $0 }
    }
}

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder

    init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}

//cache loaded images

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}
