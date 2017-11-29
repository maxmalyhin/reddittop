//
//  RedditTopViewModel.swift
//  RedditClient
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation
import RedditClientCore

protocol RedditTopViewModelDelegate: class {
    func viewModelDidUpdateLinks(_ viewModel: RedditTopViewModelProtocol)
    func viewModelDidUpdateState(_ viewModel: RedditTopViewModelProtocol, oldState: RedditTopViewModelState)

    func viewModel(_ viewModel: RedditTopViewModelProtocol, viewShouldShowPageWithURL url: URL)
}

enum RedditTopViewModelState: Int {
    case initial
    case canLoadMore
    case loadingMore
    case allDataLoaded
    case error
}

protocol RedditTopViewModelProtocol: class {
    weak var delegate: RedditTopViewModelDelegate? { set get }

    func viewDidLoad()
    func viewReachedEndOfData()
    func linkSelected(atIndex: Int)

    func encodeRestorableState(with coder: NSCoder)
    func decodeRestorableState(with coder: NSCoder)

    var linkViewModels: [RedditLinkCellViewModelProtocol] { get }
    var state: RedditTopViewModelState { get }
}

class RedditTopViewModel: RedditTopViewModelProtocol {
    private let dataProvider: RedditTopLinksDataProviderProtocol
    var delegate: RedditTopViewModelDelegate?

    private(set) var linkViewModels: [RedditLinkCellViewModelProtocol] = []

    init(dataProvider: RedditTopLinksDataProviderProtocol = RedditTopLinksDataProvider()) {
        self.dataProvider = dataProvider
    }

    private var links: [RedditLinkItem] = [] {
        didSet {
            self.linkViewModels = self.links.map({ RedditLinkCellViewModel(linkItem: $0) })
            self.delegate?.viewModelDidUpdateLinks(self)
        }
    }

    private(set) var state: RedditTopViewModelState = .initial {
        didSet {
            self.delegate?.viewModelDidUpdateState(self, oldState: oldValue)
        }
    }

    func viewDidLoad() {
        self.loadNextPage()
    }

    func viewReachedEndOfData() {
        if self.state == .canLoadMore {
            self.loadNextPage()
        }
    }

    private func loadNextPage() {
        self.state = .loadingMore
        self.dataProvider.loadNextPage(after: self.links.last) { [weak self] (result) in
            self?.handleLoadResult(result)
        }
    }

    private func handleLoadResult(_ result: LinksLoadResult) {
        switch result {
        case .noMoreItems:
            self.state = .allDataLoaded
        case .failure(error: _):
            self.state = .error
        case .success(items: let items):
            self.links.append(contentsOf: items)
            self.state = .canLoadMore
        }
    }

    func linkSelected(atIndex index: Int) {
        let url = self.links[index].link.url
        self.delegate?.viewModel(self, viewShouldShowPageWithURL: url)
    }

    // MARK: - State restoration
    func encodeRestorableState(with coder: NSCoder) {
        let encoder = JSONEncoder()

        if let encodedLinks = try? encoder.encode(self.links) {
            coder.encode(encodedLinks, forKey: "links")
        }
        coder.encode(self.state.rawValue, forKey: "state")
    }

    func decodeRestorableState(with coder: NSCoder) {
        if
            let encodedLinks = coder.decodeObject(forKey: "links") as? Data,
            let links = try? JSONDecoder().decode([RedditLinkItem].self, from: encodedLinks),
            let state = RedditTopViewModelState(rawValue: coder.decodeInteger(forKey: "state"))
        {
            self.links = links
            self.state = state
        }
    }
}
