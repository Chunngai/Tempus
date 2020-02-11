//
//  Task.swift
//  Tempus
//
//  Created by Sola on 2020/2/9.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Task {
    var content: String
    var dateInterval: DateInterval
    var remainingTime: DateComponents {
        let components: Set<Calendar.Component> = [Calendar.Component.month, .day, .hour, .minute, .second]
        return Calendar(identifier: .gregorian).dateComponents(components, from: dateInterval.end, to: dateInterval.start)
    }
    var isOverDue: Bool
    var isFinished: Bool
    var repetition: Repetition?
    var category: [String: String]
}

extension Task {
    enum Repetition {
        case day(Int)
        case week(Int)
        case month(Int)
    }
}
