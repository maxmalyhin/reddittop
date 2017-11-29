//
//  RedditTopViewController.swift
//  RedditClient
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import UIKit
import SafariServices

final class RedditTopViewController: UITableViewController {
    @IBOutlet var loadMoreIndicatorView: UIActivityIndicatorView!
    @IBOutlet var noMoreItemsLabel: UILabel!

    lazy var viewModel: RedditTopViewModelProtocol = {
        let viewModel = RedditTopViewController.createDefaultViewModel()
        viewModel.delegate = self
        return viewModel
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80

        self.updateState(new: self.viewModel.state, old: .initial)

        self.viewModel.viewDidLoad()
    }

    // MARK: View model state
    fileprivate func updateTableView() {
        // In a rear world application, I would calculate the diff between previous and new list of models and
        // then call methods such a `insertRows` of `UITableView` based on the diff to provide smooth animation,
        // because `reloadSections` usually leads to "flickering" especially in combination with dynamic cell height.
        self.tableView.reloadSections(IndexSet([0]), with: .bottom)
    }

    fileprivate func updateState(new: RedditTopViewModelState, old: RedditTopViewModelState) {
        self.updateLoadingMoreIndicator(state: new)
    }

    private func updateLoadingMoreIndicator(state: RedditTopViewModelState) {
        switch state {
        case .initial,
             .canLoadMore,
             .loadingMore:
            self.noMoreItemsLabel.isHidden = true
            self.loadMoreIndicatorView.startAnimating()
        case .allDataLoaded:
            self.noMoreItemsLabel.text = NSLocalizedString("No More Links Available", comment: "")
            self.noMoreItemsLabel.isHidden = false
            self.loadMoreIndicatorView.stopAnimating()
        case .error:
            // TODO: Implement more user freindly error handling
            self.noMoreItemsLabel.isHidden = false
            self.loadMoreIndicatorView.stopAnimating()
            self.noMoreItemsLabel.text = NSLocalizedString("Error", comment: "")
        }
    }

    // MARK: -
    fileprivate var presentedLinkURL: URL?
    func show(url: URL, animated: Bool = true) {
        let viewController = SFSafariViewController(url: url)

        // I was not able to restore SFSafariViewController state using UIKit provided methods.
        // A workaround implemented instead.
//        viewController.restorationIdentifier = "SFSafariViewController"

        // Is used to restore presented view controller manually instead.
        self.presentedLinkURL = url
        self.present(viewController, animated: animated, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension RedditTopViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.linkViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RedditLinkCell.cellIdentifier, for: indexPath) as? RedditLinkCell else {
            assertionFailure("Wrong Cell class")
            return UITableViewCell()
        }

        let cellViewModel = self.viewModel.linkViewModels[indexPath.row]
        cell.configure(withViewModel: cellViewModel, presentingViewController: self)

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        self.viewModel.linkViewModels[indexPath.row].cellWillBeDisplayed()

        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: 0) - 1
        if isLastCell {
            self.viewModel.viewReachedEndOfData()
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.linkViewModels[indexPath.row].cellWasHidden()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.linkSelected(atIndex: indexPath.row)
    }
}

extension RedditTopViewController: RedditTopViewModelDelegate {

    func viewModelDidUpdateState(_ viewModel: RedditTopViewModelProtocol, oldState: RedditTopViewModelState) {
        self.updateState(new: viewModel.state, old: oldState)
    }

    func viewModelDidUpdateLinks(_ viewModel: RedditTopViewModelProtocol) {
        self.updateTableView()
    }

    func viewModel(_ viewModel: RedditTopViewModelProtocol, viewShouldShowPageWithURL url: URL) {
        self.show(url: url)
    }
}

extension RedditTopViewController: UIDataSourceModelAssociation {
    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        guard !idx.isEmpty else { return nil }
        guard idx.row < self.viewModel.linkViewModels.count else {
            assertionFailure("Looks like an error happaned during last state encoding")
            return nil
        }

        return self.viewModel.linkViewModels[idx.row].identifier
    }

    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {

        for (index, model) in self.viewModel.linkViewModels.enumerated() {
            if model.identifier == identifier {
                return IndexPath(row: index, section: 0)
            }
        }
        return nil
    }

    override func encodeRestorableState(with coder: NSCoder) {
        self.viewModel.encodeRestorableState(with: coder)
        coder.encode(self.presentedLinkURL, forKey: "presentedLinkURL")
        super.encodeRestorableState(with: coder)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        self.viewModel.decodeRestorableState(with: coder)
        super.decodeRestorableState(with: coder)

        self.presentedLinkURL = coder.decodeObject(forKey: "presentedLinkURL") as? URL
    }

    override func applicationFinishedRestoringState() {
        // Workaround - present the link details manually.
        if let presentedURL = self.presentedLinkURL {
            DispatchQueue.main.async { [weak self] in
                self?.show(url: presentedURL, animated: false)
            }
        }
    }
}

extension RedditTopViewController {
    fileprivate static func createDefaultViewModel() -> RedditTopViewModelProtocol {
        return RedditTopViewModel()
    }
}
