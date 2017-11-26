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

    

}

extension RedditTopViewController: RedditTopViewModelDelegate {
    func viewModelDidUpdateState(_ viewModel: RedditTopViewModelProtocol) {
        
    }

    func viewModelDidUpdateLinks(_ viewModel: RedditTopViewModelProtocol) {

    }
}

extension RedditTopViewController {
    fileprivate static func createDefaultViewModel() -> RedditTopViewModelProtocol {
        return RedditTopViewModel()
    }
}
