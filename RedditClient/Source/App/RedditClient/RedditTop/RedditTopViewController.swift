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
    func show(url: URL) {
        let viewController = SFSafariViewController(url: url)
        self.present(viewController, animated: true, completion: nil)
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
        cell.configure(withViewModel: cellViewModel)

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

extension RedditTopViewController {
    fileprivate static func createDefaultViewModel() -> RedditTopViewModelProtocol {
        return RedditTopViewModel()
    }
}
