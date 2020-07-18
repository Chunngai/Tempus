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
    
    // MARK: - Initializers
    
    init(start: Date, duration: TimeInterval) {
        self.start = start
        self.end = DateInterval(start: start, duration: duration).end
    }
    
    init(start: Date?, end: Date?) {
        self.start = start
        self.end = end
    }
    
    // MARK: - Protocols
    
    static func == (lhs: Interval, rhs: Interval) -> Bool {
        return (lhs.start == rhs.start && lhs.end == rhs.end)
    }
    
    static func < (lhs: Interval, rhs: Interval) -> Bool {
        if let lhsStart = lhs.start, let rhsStart = rhs.start, lhsStart != rhsStart {
            return lhsStart < rhsStart
        } else if let lhsEnd = lhs.end, let rhsEnd = rhs.end {
            return lhsEnd < rhsEnd
        } else if lhs.start != nil || lhs.end != nil {
            return true
        } else {
            return false
        }
    }
}
