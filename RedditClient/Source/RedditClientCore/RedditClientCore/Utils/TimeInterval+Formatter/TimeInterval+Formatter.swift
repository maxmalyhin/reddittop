//
//  TimeInterval+Formatter.swift
//  RedditClientCore
//
//  Created by Maksym Malyhin on 2017-11-26.
//  Copyright © 2017 Maksym Malyhin. All rights reserved.
//

import Foundation

public extension TimeInterval {
    private enum TimeUnitsInSeconds: TimeInterval {
        case second = 1
        case minute = 60
        case hour = 3600
        case day = 86400
        case week = 604800
        case month = 2678400
        case year = 31536000

        static let allUnits: [TimeUnitsInSeconds] = [.year, .month, .week, .day, .hour, .minute, .second]
    }

    var humanFriendlyString: String {
        guard let biggestEvenStep = TimeUnitsInSeconds.allUnits.first(where: { abs(self) > $0.rawValue }) else {
            return self.string(count: 1, unit: .second)
        }

        let numberOfSteps: Int = abs(Int(self / biggestEvenStep.rawValue))
        return self.string(count: numberOfSteps, unit: biggestEvenStep)
    }

    private func string(count: Int, unit: TimeUnitsInSeconds) -> String {
        // TODO: Implement proper singular/plural string composing with localization support

        let unitString: String = {
            switch unit {
            case .second:
                return "seconds"
            case .minute:
                return "minutes"
            case .hour:
                return "hours"
            case .day:
                return "days"
            case .week:
                return "weeks"
            case .month:
                return "months"
            case .year:
                return "years"
            }
        }()
        
        return "\(count) \(unitString)"
    }
}
