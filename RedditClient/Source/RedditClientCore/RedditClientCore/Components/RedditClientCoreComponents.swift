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
}

class DefaultCoreComponents: RedditClientCoreComponents {
    public let networkManager: NetworkManagerProtocol

    private init() {
        guard let url = URL(string: "https://reddit.com") else {
            fatalError("Could not create valid base URL")
        }

        self.networkManager = NetworkManager(baseURL: url)
    }

    static let defaultComponents: RedditClientCoreComponents = DefaultCoreComponents()
}
