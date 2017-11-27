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
    var author: String { get }
    var commentsCountString: String { get }
    var dateString: String { get }
}

final class RedditLinkCellViewModel: RedditLinkCellViewModelProtocol {

    let linkItem: RedditLinkItem

    init(linkItem: RedditLinkItem) {
        self.linkItem = linkItem
    }

    var title: String {
        return self.linkItem.link.title
    }

    var author: String {
        return self.linkItem.link.author
    }

    var commentsCountString: String {
        return "\(self.linkItem.link.commentsCount)"
    }

    var dateString: String {
        return "\(self.linkItem.link.date)" // TODO: Implement
    }


}
