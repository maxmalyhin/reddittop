//
//  RedditLinkCell.swift
//  RedditClient
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import UIKit

final class RedditLinkCell: UITableViewCell {
    var viewModel: RedditLinkCellViewModelProtocol? {
        didSet {
            self.update()
        }
    }

    func configure(withViewModel viewModel: RedditLinkCellViewModelProtocol) {
        self.viewModel = viewModel
    }

    func update() {
        self.textLabel?.text = self.viewModel?.title
    }

    static let cellIdentifier = "RedditLinkCell"
}
