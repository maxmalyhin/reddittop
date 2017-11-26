//
//  FixtureLoader.swift
//  RedditClientCoreTests
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

public class FixtureLoader {
    public static func loadData(fromFileNamed fileName: String, extension extensionString: String? = nil, subdirectory: String? = nil) -> Data? {
        guard let fileURL = Bundle(for: FixtureLoader.self).url(forResource: fileName, withExtension: extensionString, subdirectory: subdirectory) else {
            return nil
        }

        return try? Data(contentsOf: fileURL)
    }
}
