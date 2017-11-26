//
//  RedditTopLinksDataProvider.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

public enum LinksLoadResult {
    case noMoreItems
    case success(items: [RedditLinkItem])
    case failure(error: Error)
}

public protocol RedditTopLinksDataProviderProtocol: class {
    typealias LoadCompletion = (_ result: LinksLoadResult) -> Void

    func loadNextPage(after: RedditLinkItem?, completion: @escaping LoadCompletion)
}

final public class RedditTopLinksDataProvider: RedditTopLinksDataProviderProtocol {
    private let networkManager: NetworkManagerProtocol
    private let pageSize: Int

    init(pageSize: Int = 25, networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.pageSize = pageSize
    }

    public func loadNextPage(after: RedditLinkItem?, completion: @escaping RedditTopLinksDataProviderProtocol.LoadCompletion) {

        let request = GetRiddetTopLinksRequest(limit: self.pageSize, afterLinkWithId: after?.fullId)
        let _ = self.networkManager.perform(request: request) { (request, error) in
            if let error = error {
                completion(.failure(error: error))
                return
            }

            if let error = request.error {
                completion(.failure(error: error))
                return
            }

            guard let items = request.response?.links else {
                completion(.noMoreItems)
                return
            }

            completion(.success(items: items))
        }
    }
}

extension RedditLinkItem {
    var fullId: String {
        return "\(self.kind)_\(self.link.identifier)"
    }
}
