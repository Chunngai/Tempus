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
