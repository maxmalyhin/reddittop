//
//  GetRiddetTopLinksRequest.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

struct RedditLinksResponse {
    let links: [RedditLink]
    let beforeId: String
    let afterId: String
}

class GetRiddetTopLinksRequest: HTTPRequestProtocol {
    private(set) var response: RedditLinksResponse?
    private(set) var error: HTTPRequestError? // TODO: Add a request specific error

    func urlRequest(baseURL: URL) -> URLRequest? {
        return nil
    }

    func handle(httpResponse: HTTPURLResponse, repsopnseData: Data, completion: () -> Void) {
        completion()
    }
}
