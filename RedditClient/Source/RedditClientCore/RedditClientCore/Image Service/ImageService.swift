//
//  ImageService.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-27.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

public protocol ImageServiceProtocol {
    typealias ImageCompletion = (_ image: UIImage?) -> Void
    typealias CancelationHandler = () -> Void

    func getImage(forURL: URL, completion: @escaping ImageCompletion) -> CancelationHandler
}

final class ImageService: ImageServiceProtocol {
    let imageCache: ImageCacheProtocol
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol, imageCache: ImageCacheProtocol) {
        self.networkManager = networkManager
        self.imageCache = imageCache
    }

    func getImage(forURL url: URL, completion: @escaping ImageServiceProtocol.ImageCompletion) -> CancelationHandler {

        var networkRequestCancelHandler: NetworkManagerProtocol.CancelationHandler?

        self.imageCache.getImage(forURL: url) { [weak self] (image) in
            guard let sSelf = self else { return }

            if let image = image {
                completion(image)
            } else {
                let imageRequest = ImageLoadRequest(url: url)

                networkRequestCancelHandler = sSelf.networkManager.perform(request: imageRequest, completion: { [weak self] request, error in
                    self?.handleNetworkResponse(request: request, error: error, completion: completion)
                })
            }
        }

        return { networkRequestCancelHandler?() }
    }

    private func handleNetworkResponse(request: ImageLoadRequest, error: Error?, completion: @escaping ImageCompletion) {

        DispatchQueue.main.async {
            completion(request.response)
        }

        if let image = request.response {
            self.imageCache.set(image: image, forURL: request.url, completion: {})
        }
    }
}
