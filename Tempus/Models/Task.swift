//
//  Task.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Task: Equatable, Comparable {
    // Vars.
    var content: String
    
    var dateInterval: DateInterval
    var totalTime: DateComponents {
        return DateComponents.MdhmGregorianDayComponents(start: dateInterval.start, end: dateInterval.end)
    }
    var availableTime: DateComponents {
        return DateComponents.MdhmGregorianDayComponents(start: Date(), end: dateInterval.end)
    }
    var isOverDue: Bool {
        return availableTime.minutes <= 0
    }

    var isFinished: Bool
    
    // Methods.
    static func == (lhs: Task, rhs: Task) -> Bool {
        return (
            lhs.content == rhs.content
            && lhs.availableTime == rhs.availableTime
            && lhs.isOverDue == rhs.isOverDue
            && lhs.isFinished == rhs.isFinished
        )
    }
    
    static func < (lhs: Task, rhs: Task) -> Bool {
//        return (lhs.dateInterval.start < rhs.dateInterval.start
//            || (!lhs.isFinished
//                && rhs.isFinished))
        
        if lhs.isFinished && !rhs.isFinished {
            return false
        } else if !lhs.isFinished && rhs.isFinished {
            return true
        } else {
            return lhs.dateInterval.start < rhs.dateInterval.start
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
        
        self = Calendar.current.date(from: dateComponents)!
    }
}

//extension DateInterval {
//    init(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int) {
//        self.init()
//
//
//    }
//
//    init(startHour: Int, startMinute: Int, durationHour: Int, durationMinute: Int) {
//        self.init()
//
//        self.start = Date(timeIntervalSinceNow: Double(startHour * 3600 + startMinute * 60))
//        self.end = Date(timeInterval: Double(durationHour * 3600 + durationMinute * 60), since: self.start)
//    }
//}

extension DateComponents {
    static func MdhmGregorianDayComponents(start: Date, end: Date) -> DateComponents {
        let components: Set<Calendar.Component> = [Calendar.Component.month, .day, .hour, .minute]
        return Calendar(identifier: .gregorian).dateComponents(components, from: start, to: end)
    }

    var minutes: Int {
        return (self.month! * 30 * 24 * 60 + self.day! * 24 * 60 + self.hour! * 60 + self.minute!)
    }
}
