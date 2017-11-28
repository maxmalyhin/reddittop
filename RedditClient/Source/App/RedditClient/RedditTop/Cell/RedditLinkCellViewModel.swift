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
    var thumbnail: UIImage? { get }

    var thumbnailUpdateHandler: (() -> Void)? { get set }

    func cellWillBeDisplayed()
    func cellWasHidden()

    func thumbnainDidTap()

    var presentImageHandler: ((_ imageURL: URL) -> Void)? { get set }
}

final class RedditLinkCellViewModel: RedditLinkCellViewModelProtocol {

    let imageService: ImageServiceProtocol

    let linkItem: RedditLinkItem

    init(linkItem: RedditLinkItem,
         imageService: ImageServiceProtocol = ImageServiceProvider.defaultImageService) {
        self.linkItem = linkItem
        self.imageService = imageService
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

    var thumbnail: UIImage? {
        didSet {
            self.thumbnailUpdateHandler?()
        }
    }
    var thumbnailUpdateHandler: (() -> Void)?

    var imageLoadCancelClosure: ImageServiceProtocol.CancelationHandler? {
        willSet {
            self.imageLoadCancelClosure?()
        }
    }

    func cellWillBeDisplayed() {
        self.thumbnail = #imageLiteral(resourceName: "reddit-icon")
        
        guard let thumbnailURL = self.linkItem.link.thumbnailURL else { return }

        self.imageLoadCancelClosure = self.imageService.getImage(forURL: thumbnailURL) { [weak self] image in

            if image != nil {
                self?.thumbnail = image
            }
        }
    }
    
    func cellWasHidden() {
        self.imageLoadCancelClosure?()
    }

    var presentImageHandler: ((URL) -> Void)?
    func thumbnainDidTap() {
        guard let previewImage = self.linkItem.link.preview?.images.first else { return }

        self.presentImageHandler?(previewImage.source.url)
    }
}
