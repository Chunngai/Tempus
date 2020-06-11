//
//  Task.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Task: Equatable, Comparable, Codable {
    var content: String!
    var dateInterval: Interval!
    var isFinished: Bool!
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return (
            lhs.content == rhs.content
            && lhs.dateInterval == rhs.dateInterval
            && lhs.isFinished == rhs.isFinished
        )
    }
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        if lhs.isFinished && !rhs.isFinished {
            return false
        } else if !lhs.isFinished && rhs.isFinished {
            return true
        } else {
            return lhs.dateInterval < rhs.dateInterval
        }
    }
}

extension Date {
    init(hour: Int, minute: Int) {
        let now = Date()

        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: now)
        dateComponents.month = Calendar.current.component(.month, from: now)
        dateComponents.day = Calendar.current.component(.day, from: now)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
	
        self = Calendar.current.date(from: dateComponents)!  // Timezone of the date generated is according to the system.
    }
    
    func dateOfCurrentTimeZone() -> Date {
        return Date(timeInterval: TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self)
    }
    
    var shortWeekdaySymbol: String {
        let calendar = Calendar(identifier: .gregorian)  // Timezone of the date generated is according to the system.
        let gmtDate = Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self)
        
        let weekday = calendar.component(.weekday, from: gmtDate)
        return calendar.shortWeekdaySymbols[weekday - 1]
    }
}

extension TimeInterval {
    static var secondsOfCurrentTimeZoneFromGMT: Double {
        return Double(TimeZone.current.secondsFromGMT())
    }
}
