//
//  HTTPRequest.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

protocol HTTPRequestProtocol: class {
    associatedtype ResponseType
    associatedtype ErrorType: Error

    var response: ResponseType? { get }
    var error: ErrorType? { get }

    func urlRequest(baseURL: URL) -> URLRequest?

    typealias HandlingCompletion = () -> Void
    func handle(httpResponse: HTTPURLResponse, repsopnseData: Data, completion: HandlingCompletion)
}
