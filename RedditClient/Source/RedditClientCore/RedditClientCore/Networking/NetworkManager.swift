//
//  NetworkManager.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

enum HTTPRequestError: Error {
    case unknown
}

protocol NetworkManagerProtocol: class {
    typealias RequestCompletion<RequestType: HTTPRequestProtocol> = (_ request: RequestType, _ error: HTTPRequestError?) -> Void

    typealias CancelationHandler = () -> Void

    func perform<RequestType: HTTPRequestProtocol>(request: RequestType,
                                                   completion: @escaping RequestCompletion<RequestType>) -> CancelationHandler
}

final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func perform<RequestType>(request: RequestType, completion: @escaping (RequestType, HTTPRequestError?) -> Void) -> NetworkManagerProtocol.CancelationHandler where RequestType : HTTPRequestProtocol {

        return {}
    }
}
