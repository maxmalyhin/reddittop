//
//  RedditLink.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

public struct RedditLinkItem: Decodable {
    let kind: String
    let link: RedditLink

    enum CodingKeys : String, CodingKey {
        case kind
        case link = "data"
    }
}

public struct RedditLink: Decodable {
    let identifier: String
    let title: String
    let author: String
    let date: Date
    let commentsCount: Int
    let thumbnailURL: URL

    enum CodingKeys : String, CodingKey {
        case identifier = "id"
        case title
        case author
        case date = "created_utc"
        case commentsCount = "num_comments"
        case thumbnailURL = "thumbnail"
    }
}
