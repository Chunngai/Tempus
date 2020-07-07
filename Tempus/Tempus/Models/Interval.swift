//
//  File.swift
//  Tempus
//
//  Created by Sola on 2020/6/11.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Interval: Equatable, Comparable, Codable {
    var start: Date?
    var end: Date?
    var duration: TimeInterval? {
        if let start = self.start, let end = self.end {
            return DateInterval(start: start, end: end).duration
        } else {
            return nil
        }
    }
    
    // Initializers.
    init(start: Date, duration: TimeInterval) {
        self.start = start
        self.end = DateInterval(start: start, duration: duration).end
    }
    
    init(start: Date?, end: Date?) {
        self.start = start
        self.end = end
    }
    
    // Equatable protocol.
    static func == (lhs: Interval, rhs: Interval) -> Bool {
        return (lhs.start == rhs.start && lhs.end == rhs.end)
    }
    
    // Comparable protocol.
    static func < (lhs: Interval, rhs: Interval) -> Bool {
        if let lhsEnd = lhs.end, let rhsEnd = rhs.end {
            if lhsEnd != rhsEnd {
                return lhsEnd < rhsEnd
            } else if let lhsStart = lhs.start, let rhsStart = rhs.start {
                return lhsStart < rhsStart
            }
        } else if lhs.end != nil && rhs.end == nil {
            return true
        }
        return false
    }
}
