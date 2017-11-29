//
//  RedditImage.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-27.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

public struct RedditImage: Codable {
    public struct Variant: Codable {
        public let url: URL
        public let height: CGFloat
        public let width: CGFloat
    }

    public let source: Variant
}

// Expected JSON to decode
/*
 {
 "source": {
 "url": "https://i.redditmedia.com/vQf7k4JuKU6SCzZ7EdUwXqhapwUoWDvTvbszQK_Bge8.jpg?s=10d9bfb6c74405185e1277b1257d3874",
 "width": 480,
 "height": 360
 },
 "resolutions": [
 {
 "url": "https://i.redditmedia.com/vQf7k4JuKU6SCzZ7EdUwXqhapwUoWDvTvbszQK_Bge8.jpg?fit=crop&amp;crop=faces%2Centropy&amp;arh=2&amp;w=108&amp;s=b73a3b9d11f3bce38904bea74827ac19",
 "width": 108,
 "height": 81
 },
 {
 "url": "https://i.redditmedia.com/vQf7k4JuKU6SCzZ7EdUwXqhapwUoWDvTvbszQK_Bge8.jpg?fit=crop&amp;crop=faces%2Centropy&amp;arh=2&amp;w=216&amp;s=dbc28f5acf831b7c5adc3c52219cb9e5",
 "width": 216,
 "height": 162
 },
 {
 "url": "https://i.redditmedia.com/vQf7k4JuKU6SCzZ7EdUwXqhapwUoWDvTvbszQK_Bge8.jpg?fit=crop&amp;crop=faces%2Centropy&amp;arh=2&amp;w=320&amp;s=db9c49433db7b4503dc94d1c35981b07",
 "width": 320,
 "height": 240
 }
 ],
 "variants": {},
 "id": "Z8Lb9cpR_VymKJs5P8EYNUfEXi5mB-Nc4kb7nUaEJ8M"
 }
 */
