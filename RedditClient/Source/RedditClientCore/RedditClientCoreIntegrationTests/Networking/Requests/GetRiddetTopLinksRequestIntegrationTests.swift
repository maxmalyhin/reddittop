//
//  GetRiddetTopLinksRequestIntegrationTests.swift
//  RedditClientCoreIntegrationTests
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import XCTest
@testable import RedditClientCore

class GetRiddetTopLinksRequestIntegrationTests: XCTestCase {
    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()

        self.networkManager = NetworkManager(baseURL: URL(string: "https://reddit.com")!)
    }

    func testThat_WhenRequestIsCorrect_ThenResponseIsCorrect() {
        let linksCountToRequest = 2
        let request = GetRiddetTopLinksRequest(limit: linksCountToRequest)

        let requestExpectation = self.expectation(description: "Request complited expectation")
        let _ = self.networkManager.perform(request: request) { request, error in
            XCTAssertNil(error)
            XCTAssertNotNil(request.response)

            XCTAssertEqual(request.response?.links.count, linksCountToRequest)

            requestExpectation.fulfill()
        }

        self.wait(for: [requestExpectation], timeout: 2)
    }
    
}
