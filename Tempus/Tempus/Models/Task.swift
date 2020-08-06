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
    var category: String!
    var repetition: Repetition!
    
    // MARK: - Initializers
    
    init(content: String? = "", dateInterval: Interval? = Interval(start: nil, end: nil), isFinished: Bool? = false, category: String? = "", repetition: Repetition? = nil) {
        self.content = content
        self.dateInterval = dateInterval
        self.isFinished = isFinished
        self.category = category
        self.repetition = repetition
    }
    
    // MARK: - Customized funcs
    
    mutating func nextRepetition() {
        dateInterval = Interval(start: repetition.next(), duration: dateInterval.duration!)
        
        if repetition.repeatTueDate < dateInterval.end! {
            isFinished = true
        } else {
            repetition.lastDate = repetition.next()
        }
    }
    
    // MARK: - Protocols
    
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

extension Task {
    var isOverdue: Bool {
        if isFinished {
            return false
        }
        
        guard let dateIntervalEnd = self.dateInterval.end else {
            return false
        }
        
        return dateIntervalEnd < Date().currentTimeZone()
    }
}

extension Date {
    // Creates a date with hour and min.
    init(hour: Int, minute: Int) {
        var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute
	
        self = Calendar.current.date(from: dateComponents)!  // Timezone of the date generated is according to the system.
    }
    
    func currentTimeZone() -> Date {
        return Date(timeInterval: TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self)
    }
}

extension TimeInterval {
    static var secondsOfCurrentTimeZoneFromGMT: Double {
        return Double(TimeZone.current.secondsFromGMT())
    }
}
