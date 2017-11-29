//
//  RedditTopViewModelTests.swift
//  RedditClientTests
//
//  Created by Maksym Malyhin on 2017-11-28.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import XCTest
@testable import RedditClientCore
@testable import RedditClient

class RedditTopViewModelTests: XCTestCase {

    var mockDataProvider: MockRedditTopLinksDataProvider!
    var viewModel: RedditTopViewModel!

    override func setUp() {
        super.setUp()

        self.mockDataProvider = MockRedditTopLinksDataProvider()
        self.viewModel = RedditTopViewModel(dataProvider: self.mockDataProvider)
    }

    func testThat_WhenViewModelIsCreated_ItsStateIsInitial() {
        XCTAssertEqual(self.viewModel.state, .initial)
    }

    func testThat_WhenViewDidLoadCalled_ThenFirstPageIsLoaded() {
        var loadNextCalled = false
        self.mockDataProvider.loadNextHandler = { after, _ in
            loadNextCalled = true
            XCTAssertNil(after)
        }

        self.viewModel.viewDidLoad()

        XCTAssertTrue(loadNextCalled)
    }

    func testThat_WhenLoadingData_ThenStateIsLoadingMore() {
        self.viewModel.viewDidLoad()

        XCTAssertEqual(self.viewModel.state, .loadingMore)
    }

    func testThat_WhenEmptyResponseReceived_TheStateIsAllDataLoaded() {
        var loadNextCalled = false
        self.mockDataProvider.loadNextHandler = { after, completion in
            loadNextCalled = true

            completion(.noMoreItems)
        }

        self.viewModel.viewDidLoad()

        XCTAssertTrue(loadNextCalled)
        XCTAssertEqual(self.viewModel.state, .allDataLoaded)
    }

    // TODO: Test other state transitions in a similar maner

    func testThat_ViewModelStateCanBeRestored() {
        // Prepare view model
        self.mockDataProvider.loadNextHandler = { after, completion in
            completion(.success(items: self.createLinks()))
        }
        self.viewModel.viewDidLoad()
        XCTAssert(self.viewModel.linkViewModels.count > 0)

        // Archive
        let archiver = NSKeyedArchiver()
        self.viewModel.encodeRestorableState(with: archiver)
        let data = archiver.encodedData

        // Unarchive
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        let restoredViewModel = RedditTopViewModel(dataProvider: MockRedditTopLinksDataProvider())
        restoredViewModel.decodeRestorableState(with: unarchiver)

        // Check
        XCTAssertEqual(restoredViewModel.state, self.viewModel.state)
        XCTAssertEqual(restoredViewModel.linkViewModels.map({ $0.identifier }), self.viewModel.linkViewModels.map({ $0.identifier }))

    }

    // TODO: Add tests for the rest of the view model behaviour.

    // MARK: Helper
    func createLinks() -> [RedditLinkItem] {
        guard let responseData = FixtureLoader.loadData(fromFileNamed: "GetRiddetTopLinksValidResponse.json") else {
            XCTAssertTrue(false, "Cannot load fixture")
            return []
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970


        guard let response = try? decoder.decode(RedditLinksResponse.self, from: responseData) else {
            XCTAssertTrue(false, "Cannot parse fixture")
            return []
        }

        return response.data.links
    }

}

class MockRedditTopLinksDataProvider: RedditTopLinksDataProviderProtocol {
    var loadNextHandler: ((_ after: RedditLinkItem?, _ completion: @escaping RedditTopLinksDataProviderProtocol.LoadCompletion) -> Void)?
    func loadNextPage(after: RedditLinkItem?, completion: @escaping RedditTopLinksDataProviderProtocol.LoadCompletion) {
        self.loadNextHandler?(after, completion)
    }
}
