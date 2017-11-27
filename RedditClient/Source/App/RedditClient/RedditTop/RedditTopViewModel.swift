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
}

enum RedditTopViewModelState {
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
}
