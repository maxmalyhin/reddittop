//
//  RedditLinkCell.swift
//  RedditClient
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import UIKit
import SafariServices

final class RedditLinkCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var numberOfCommentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    var presentingViewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.configureImageViewTap()
    }

    var viewModel: RedditLinkCellViewModelProtocol? {
        didSet {
            self.update()
            self.viewModel?.thumbnailUpdateHandler = { [weak self] in
                self?.updateThumbnail()
            }

            self.viewModel?.presentImageHandler = { [weak self] url in
                self?.showImage(withURL: url)
            }
        }
    }

    func configure(withViewModel viewModel: RedditLinkCellViewModelProtocol,
                   presentingViewController: UIViewController?) {
        self.viewModel = viewModel
        self.presentingViewController = presentingViewController
    }

    private func update() {
        self.titleLabel.text = self.viewModel?.title
        self.authorLabel.text = self.viewModel?.submittedBy
        self.numberOfCommentLabel.text = self.viewModel?.commentsCountString
    }

    private func updateThumbnail() {
        self.thumbnailImageView.image = self.viewModel?.thumbnail
    }

    // MARK: Image view tap
    private var imageViewTapGestureRecognizer: UITapGestureRecognizer!
    private func configureImageViewTap() {
        self.imageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapRecognized))
        self.thumbnailImageView.addGestureRecognizer(self.imageViewTapGestureRecognizer)
    }

    @objc
    private func imageViewTapRecognized() {
        self.viewModel?.thumbnainDidTap()
    }

    private func showImage(withURL url: URL) {
        guard let presentingViewController = self.presentingViewController else { return }
        let safariViewController = SFSafariViewController(url: url)
        presentingViewController.present(safariViewController, animated: true, completion: nil)
    }

    static let cellIdentifier = "RedditLinkCell"
}
