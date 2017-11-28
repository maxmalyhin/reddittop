//
//  ImageLoadRequest.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-27.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

final class ImageLoadRequest: HTTPRequestProtocol {
    enum LoadError: Error {
        case cannotDecodeImageData
    }

    private(set) var response: UIImage?
    private(set) var error: LoadError?

    let url: URL

    init(url: URL) {
        self.url = url
    }

    func urlRequest(baseURL: URL) -> URLRequest? {
        return URLRequest(url: self.url)
    }

    func handle(httpResponse: HTTPURLResponse, repsopnseData: Data, completion: HandlingCompletion) {
        let image = UIImage(data: repsopnseData)

        self.response = image
        self.error = image == nil ? .cannotDecodeImageData : nil
        completion()
    }
}
