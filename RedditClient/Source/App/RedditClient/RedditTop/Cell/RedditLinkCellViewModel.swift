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

    var submittedBy: String { get }
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
        // TODO: Implement proper singular/plural string composing with localization support
        return "\(self.linkItem.link.commentsCount) comment(s)"
    }

    var dateString: String {
        return "\(self.linkItem.link.date)" // TODO: Implement
    }

    var submittedBy: String {
        let relativeTimeInterval = self.linkItem.link.date.timeIntervalSinceNow
        assert(relativeTimeInterval <= 0, "The submit date must be in the past")

        return "submitted \(relativeTimeInterval.humanFriendlyString) ago by \(self.author) "
    }
}
