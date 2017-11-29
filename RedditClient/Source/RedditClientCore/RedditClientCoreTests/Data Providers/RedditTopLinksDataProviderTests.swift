//
//  RedditTopLinksDataProviderTests.swift
//  RedditClientCoreTests
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import XCTest
@testable import RedditClientCore

class RedditTopLinksDataProviderTests: XCTestCase {
    fileprivate var mockNetworkManager: MockNetworkManager = MockNetworkManager()
    var dataProvider: RedditTopLinksDataProvider!

    override func setUp() {
        super.setUp()

        self.dataProvider = RedditTopLinksDataProvider(pageSize: 10, networkManager: self.mockNetworkManager)
    }

    func testThat_WhenErrorReceived_ThenResultIsError() {
        self.mockNetworkManager.performRequestHandler = { request, completion  in
            completion(request, HTTPRequestError.unknown)
            return {}
        }

        let completionCalledExpectation = self.expectation(description: "Completion Called")
        self.dataProvider.loadNextPage(after: nil) { result in
            completionCalledExpectation.fulfill()

            switch result {
            case .failure(error: _): break
            default:
                XCTAssertTrue(false, "\(result) != .failure")
            }
        }

        self.wait(for: [completionCalledExpectation], timeout: 0.2)
    }

    func testThat_WhenEmptyItemsListResponseReceived_ThenResultIsNoMoreItems() {
        // TODO: Implement
    }

    func testThat_WhenItemsReceived_ThenResultIsSuccess() {
        // TODO: Implement
    }
}

fileprivate class MockNetworkManager: NetworkManagerProtocol {
    typealias PerformRequestHandler = (_ request: GetRiddetTopLinksRequest,
        _ completion: @escaping RequestCompletion<GetRiddetTopLinksRequest>) -> CancelationHandler

    var performRequestHandler: PerformRequestHandler?

    func perform(networkRequest: GetRiddetTopLinksRequest,
                 completion: @escaping RequestCompletion<GetRiddetTopLinksRequest>) -> CancelationHandler {
        return self.performRequestHandler?(networkRequest, completion) ?? {}
    }

    func perform<RequestType: HTTPRequestProtocol>(request: RequestType, completion: @escaping RequestCompletion<RequestType>) -> CancelationHandler {
        guard let experienceRequest = request as? GetRiddetTopLinksRequest else { return {} }

        return self.perform(networkRequest: experienceRequest) { (request, error) in
            completion(request as! RequestType, error)
        }
    }
}
