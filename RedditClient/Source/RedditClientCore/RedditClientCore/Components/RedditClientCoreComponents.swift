//
//  RedditClientCoreComponents.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

protocol RedditClientCoreComponents: class {
    var networkManager: NetworkManagerProtocol { get }
    var imageService: ImageServiceProtocol { get }
}

extension RedditClientCoreComponents {
    static var defaultComponents: RedditClientCoreComponents {
        return DefaultCoreComponents.defaultComponents
    }
}

class DefaultCoreComponents: RedditClientCoreComponents {
    public let networkManager: NetworkManagerProtocol

    public let imageService: ImageServiceProtocol
    private let imageCache: ImageCacheProtocol
    private let imageLoaderNetworkManager: NetworkManagerProtocol

    private init() {
        guard let url = URL(string: "https://reddit.com") else {
            fatalError("Could not create valid base URL")
        }

        self.networkManager = NetworkManager(baseURL: url)
        self.imageLoaderNetworkManager = ImageService.createDefaultNetworkManager(baseURL: url)
        self.imageCache = SimpleImageCache()
        self.imageService = ImageService(networkManager: self.networkManager, imageCache: self.imageCache)
    }

     static let defaultComponents: RedditClientCoreComponents = DefaultCoreComponents()
}

extension ImageService {
    static func createDefaultNetworkManager(baseURL: URL) -> NetworkManagerProtocol {
        let configuration = URLSessionConfiguration.default
        let imageURLCache = URLCache(memoryCapacity: 40_000_000, diskCapacity: 100_000_000, diskPath: "redditImageCache")
        configuration.urlCache = imageURLCache
        let urlSession = URLSession(configuration: configuration)

        let networkManager = NetworkManager(baseURL: baseURL, session: urlSession)
        return networkManager
    }
}
