//
//  Course.swift
//  Tempus
//
//  Created by Sola on 2020/8/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Course: Equatable {
    var name: String!
    var instructor: String!
    var weekNumber: Int
    
    // MARK: - Initializers
    
    init(name: String, instructor: String, weekNumber: Int = 16) {
        self.name = name
        self.instructor = instructor
        self.weekNumber = weekNumber
    }
    
    // MARK: - Protocols
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return (
            lhs.name == rhs.name
                && lhs.instructor == rhs.instructor
                && lhs.weekNumber == rhs.weekNumber
        )
    }
}

struct Section: Equatable {
    var course: Course!
    var weekday: Int!
    var start: Int!
    var end: Int!
    var classroom: String!
    
    static var sectionNumber = 15
    
    static var time: [Int: (start: Date, end: Date)] {
        var time = [Int: (start: Date, end: Date)]()
        
        let startTime = [
            1: Date(hour: 8, minute: 30),
            2: Date(hour: 9, minute: 10),
            3: Date(hour: 10, minute: 10),
            4: Date(hour: 10, minute: 50),
            5: Date(hour: 11, minute: 35),
            6: Date(hour: 12, minute: 30),
            7: Date(hour: 13, minute: 10),
            8: Date(hour: 14, minute: 00),
            9: Date(hour: 14, minute: 40),
            10: Date(hour: 15, minute: 40),
            11: Date(hour: 16, minute: 20),
            12: Date(hour: 18, minute: 30),
            13: Date(hour: 19, minute: 10),
            14: Date(hour: 20, minute: 00),
            15: Date(hour: 20, minute: 40),
        ]
        
        for elem in startTime {
            let start = startTime[elem.key]!
            
            time[elem.key] = (
                start: start.currentTimeZone(),
                end: Date(timeInterval: 40 * 60, since: start).currentTimeZone()
            )
        }
        
        return time
    }
    
    // MARK: Initializers
    
    init(course: Course, weekday: Int, start: Int, end: Int, classroom: String) {
        self.course = course
        self.weekday = weekday
        self.start = start
        self.end = end
        self.classroom = classroom
    }
    
    // MARK: - Protocols
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        return (lhs.course == rhs.course
                && lhs.weekday == rhs.weekday
                && lhs.start == rhs.start
                && lhs.end == rhs.end
                && lhs.classroom == rhs.classroom
        )
    }
}
