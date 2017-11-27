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

    init(pageSize: Int, networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.pageSize = pageSize
    }

    public convenience init(pageSize: Int = 25) {
        self.init(pageSize: pageSize, networkManager: DefaultCoreComponents.defaultComponents.networkManager)
    }

    public func loadNextPage(after: RedditLinkItem?, completion: @escaping RedditTopLinksDataProviderProtocol.LoadCompletion) {

        let request = GetRiddetTopLinksRequest(limit: self.pageSize, afterLinkWithId: after?.fullId)

        let callCompletionInMainTread: LoadCompletion = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let _ = self.networkManager.perform(request: request) { (request, error) in
            if let error = error {
                callCompletionInMainTread(.failure(error: error))
                return
            }

            if let error = request.error {
                callCompletionInMainTread(.failure(error: error))
                return
            }

            guard let items = request.response?.links else {
                callCompletionInMainTread(.noMoreItems)
                return
            }

            callCompletionInMainTread(.success(items: items))
        }
    }
}

extension RedditLinkItem {
    var fullId: String {
        return "\(self.kind)_\(self.link.identifier)"
    }
}
