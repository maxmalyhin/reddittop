//
//  RedditLink.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

public struct RedditLinkItem: Decodable {
    public let kind: String
    public let link: RedditLink

    enum CodingKeys : String, CodingKey {
        case kind
        case link = "data"
    }
}

public struct RedditLink: Decodable {
    public let identifier: String
    public let title: String
    public let author: String
    public let date: Date
    public let commentsCount: Int
    public let thumbnailURL: URL?

    enum CodingKeys : String, CodingKey {
        case identifier = "id"
        case title
        case author
        case date = "created_utc"
        case commentsCount = "num_comments"
        case thumbnailURL = "thumbnail"
    }
}
