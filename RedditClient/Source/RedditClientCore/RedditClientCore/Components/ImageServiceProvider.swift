//
//  ImageServiceProvider.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-27.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

public final class ImageServiceProvider {
    public static var defaultImageService: ImageServiceProtocol {
        return DefaultCoreComponents.defaultComponents.imageService
    }
}
