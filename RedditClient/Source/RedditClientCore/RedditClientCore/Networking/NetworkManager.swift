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
    case cannotCreateURLRequest
    case unexpectedURLResponse
}

protocol NetworkManagerProtocol: class {
    typealias RequestCompletion<RequestType: HTTPRequestProtocol> = (_ request: RequestType, _ error: HTTPRequestError?) -> Void

    typealias CancelationHandler = () -> Void

    func perform<RequestType: HTTPRequestProtocol>(request: RequestType,
                                                   completion: @escaping RequestCompletion<RequestType>) -> CancelationHandler
}

final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    private let baseURL: URL
    private let responseDeserializationQueue: DispatchQueue

    init(baseURL: URL, session: URLSession = NetworkManager.createDefaultURLSession()) {
        self.baseURL = baseURL
        self.session = session
        self.responseDeserializationQueue = DispatchQueue(label: "NetworkManager.responseDeserializationQueue",
                                                          qos: .userInitiated,
                                                          attributes: [.concurrent],
                                                          autoreleaseFrequency: .workItem,
                                                          target: nil)
    }

    static func createDefaultURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30

        let session = URLSession(configuration: configuration)
        return session
    }

    func perform<RequestType>(request: RequestType, completion: @escaping (RequestType, HTTPRequestError?) -> Void) -> NetworkManagerProtocol.CancelationHandler where RequestType : HTTPRequestProtocol {

        guard let urlRequest = request.urlRequest(baseURL: self.baseURL) else {
            completion(request, .cannotCreateURLRequest)
            return {}
        }

        let task = self.session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            self.responseDeserializationQueue.async {
                guard
                    let httpResponse = urlResponse as? HTTPURLResponse,
                    let data = data
                else {
                    completion(request, .unexpectedURLResponse)
                    return
                }

                request.handle(httpResponse: httpResponse, repsopnseData: data, completion: {
                    completion(request, nil)
                })
            }
        }

        task.resume()

        return { [weak task] in
            task?.cancel()
        }
    }
}
