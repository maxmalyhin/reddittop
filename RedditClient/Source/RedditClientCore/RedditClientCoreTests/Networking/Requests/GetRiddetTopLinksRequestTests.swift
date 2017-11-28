//
//  GetRiddetTopLinksRequestTests.swift
//  RedditClientTests
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import XCTest
@testable import RedditClientCore

class GetRiddetTopLinksRequestTests: XCTestCase {
    var baseURL: URL! = URL(string:"https://reddit.com")

    func testThat_WhenRequestInitializedWithLimitAndAfterId_ThenTheseParametersPresentInURLRequest() {
        let limit = 20
        let afterId = "t3_afterId"

        let request = GetRiddetTopLinksRequest(limit: limit, afterLinkWithId: afterId)
        guard let url = request.urlRequest(baseURL: self.baseURL)?.url else {
            XCTAssertTrue(false, "URL must be not nil")
            return
        }

        XCTAssertEqual(url.getParameter(withName: "limit"), "\(limit)")
        XCTAssertEqual(url.getParameter(withName: "after"), afterId)
    }

    func testThat_WhenRequestInitializedWithLimit_ThenAfterIdIsNotAddedToURLRequest() {
        let limit = 20

        let request = GetRiddetTopLinksRequest(limit: limit)
        guard let url = request.urlRequest(baseURL: self.baseURL)?.url else {
            XCTAssertTrue(false, "URL must be not nil")
            return
        }

        XCTAssertEqual(url.getParameter(withName: "limit"), "\(limit)")
        XCTAssertNil(url.getParameter(withName: "after"))
    }

    func testThat_WhenValidResponseReceived_ThenItCanBeParsed() {
        guard let responseData = FixtureLoader.loadData(fromFileNamed: "GetRiddetTopLinksValidResponse.json") else {
            XCTAssertTrue(false, "Cannot load fixture")
            return
        }

        let response = HTTPURLResponse.defaultResponse(withCode: 200)

        var completionCalled = false
        let completionHandler = {
            completionCalled = true
        }

        let request = GetRiddetTopLinksRequest(limit: 10)

        request.handle(httpResponse: response, repsopnseData: responseData, completion: completionHandler)

        XCTAssertTrue(completionCalled)

        XCTAssertNotNil(request.response)
        XCTAssertNil(request.error)

        XCTAssertEqual(request.response?.afterId, "t3_7fhn5d")
        XCTAssertNil(request.response?.beforeId)

        let redditLink = request.response?.links.first

        XCTAssertEqual(redditLink?.link.identifier, "7fhn5d")
        XCTAssertEqual(redditLink?.link.url.absoluteString, "https://gfycat.com/UnhappyPettyAlaskanmalamute")
        XCTAssertEqual(redditLink?.link.title, "My dog became a Sith Lord.")
        XCTAssertEqual(redditLink?.link.author, "Deathkru")
        XCTAssertEqual(redditLink?.link.commentsCount, 1226)
        XCTAssertEqual(redditLink?.link.date, Date(timeIntervalSince1970: 1511640672))
        XCTAssertEqual(redditLink?.link.thumbnailURL?.absoluteString, "https://b.thumbs.redditmedia.com/D16L9-URUROjmUnEzMOT49Yv9EA4gz0Y3pgToDGFOHk.jpg")

        let priviewImageSourceURL = redditLink?.link.preview?.images.first?.source.url
        XCTAssertEqual(priviewImageSourceURL?.absoluteString, "https://i.redditmedia.com/BDnjiwPvPuGWrbzV8ZXiba8C5XkR1aZN1x1dRXWwDdo.gif?fm=jpg&amp;s=e7e1e28b42b7cb59e672a01098e5f15e")
    }

    func testThat_WhenInvalidResponseReceived_ThenItIsParsedWithError() {
        guard let responseData = FixtureLoader.loadData(fromFileNamed: "Empty.json") else {
            XCTAssertTrue(false, "Cannot load fixture")
            return
        }

        let response = HTTPURLResponse.defaultResponse(withCode: 200)

        var completionCalled = false
        let completionHandler = {
            completionCalled = true
        }

        let request = GetRiddetTopLinksRequest(limit: 10)
        request.handle(httpResponse: response, repsopnseData: responseData, completion: completionHandler)

        XCTAssertTrue(completionCalled)

        XCTAssertNil(request.response)
        XCTAssertNotNil(request.error)
    }

    // TODO: Extend to validate error handling.
}

extension URL {
    func getParameter(withName name: String) -> String? {
        guard
            let urlComponents = URLComponents.init(url: self, resolvingAgainstBaseURL: true),
            let queryItems = urlComponents.queryItems,
            let value = queryItems.first(where: { $0.name == name })?.value
        else {
            return nil
        }

        return value
    }
}

extension HTTPURLResponse {
    class func defaultResponse(withCode code: Int = 200) -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "http://localhost")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
}
