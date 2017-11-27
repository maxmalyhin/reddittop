//
//  RedditLinkCell.swift
//  RedditClient
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import UIKit

final class RedditLinkCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var numberOfCommentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    var viewModel: RedditLinkCellViewModelProtocol? {
        didSet {
            self.update()
        }
    }

    func configure(withViewModel viewModel: RedditLinkCellViewModelProtocol) {
        self.viewModel = viewModel
    }

    func update() {
        self.titleLabel.text = self.viewModel?.title
        self.authorLabel.text = self.viewModel?.author
        self.numberOfCommentLabel.text = self.viewModel?.commentsCountString
        self.dateLabel.text = self.viewModel?.dateString
    }

    static let cellIdentifier = "RedditLinkCell"
}
