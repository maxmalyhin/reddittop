//
//  RedditLinkCellViewModel.swift
//  RedditClient
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation
import RedditClientCore

protocol RedditLinkCellViewModelProtocol: class {
    var title: String { get }
}

final class RedditLinkCellViewModel: RedditLinkCellViewModelProtocol {
    let linkItem: RedditLinkItem

    init(linkItem: RedditLinkItem) {
        self.linkItem = linkItem
    }

    var title: String {
        return self.linkItem.link.title
    }
}
