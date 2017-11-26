//
//  GetRiddetTopLinksRequest.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

struct RedditLinksResponse: Decodable {
    struct Data: Decodable {
        let links: [RedditLinkItem]
        let beforeId: String?
        let afterId: String?

        enum CodingKeys : String, CodingKey {
            case links = "children"
            case beforeId = "before"
            case afterId = "after"

        }
    }

    let data: Data
}

class GetRiddetTopLinksRequest: HTTPRequestProtocol {
    private(set) var response: RedditLinksResponse.Data?
    private(set) var error: RequestError?

    private let limit: Int
    private let afterId: String?

    init(limit: Int, afterLinkWithId afterId: String? = nil) {
        self.limit = limit
        self.afterId = afterId
    }

    func urlRequest(baseURL: URL) -> URLRequest? {
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { return nil }

        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "limit", value: "\(self.limit)"))

        if let afterId = self.afterId {
            queryItems.append(URLQueryItem(name: "after", value: afterId))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return nil }

        let request = URLRequest(url: url)
        return request
    }

    func handle(httpResponse: HTTPURLResponse, repsopnseData: Data, completion: () -> Void) {
        guard httpResponse.statusCode == 200 else {
            self.error = .wrongHTTPResponseCode
            completion()
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        do {
            let response = try decoder.decode(RedditLinksResponse.self, from: repsopnseData)
            self.response = response.data

        } catch {
            self.error = .cannotDecodeResponse(error: error)
        }

        completion()
    }
}

extension GetRiddetTopLinksRequest {
    enum RequestError: Error {
        case unknown
        case wrongHTTPResponseCode
        case cannotDecodeResponse(error: Error)
    }
}
