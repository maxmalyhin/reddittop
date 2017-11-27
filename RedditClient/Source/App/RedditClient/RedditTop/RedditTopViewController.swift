//
//  RedditTopViewController.swift
//  RedditClient
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import UIKit

final class RedditTopViewController: UITableViewController {
    lazy var viewModel: RedditTopViewModelProtocol = {
        let viewModel = RedditTopViewController.createDefaultViewModel()
        viewModel.delegate = self
        return viewModel
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureWithViewModel()
        self.viewModel.viewDidLoad()
    }

    // MARK: View model state
    private func configureWithViewModel() {
        self.updateTableView()
        self.updateState()
    }

    fileprivate func updateTableView() {
        self.tableView.reloadSections(IndexSet([0]), with: .automatic)
    }

    fileprivate func updateState() {
        
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
}

extension RedditTopViewController: RedditTopViewModelDelegate {
    func viewModelDidUpdateState(_ viewModel: RedditTopViewModelProtocol) {
        self.updateState()
    }

    func viewModelDidUpdateLinks(_ viewModel: RedditTopViewModelProtocol) {
        self.updateTableView()
    }
}

extension RedditTopViewController {
    fileprivate static func createDefaultViewModel() -> RedditTopViewModelProtocol {
        return RedditTopViewModel()
    }
}
