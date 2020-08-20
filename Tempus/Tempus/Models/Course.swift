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
    var sections: [Section]!
    var instructor: String!
    var weekNumber: Int!
    
    // MARK: - Initializers
    
    init(name: String, sections: [Section], instructor: String, weekNumber: Int = 16) {
        self.name = name
        self.sections = sections
        self.instructor = instructor
        self.weekNumber = weekNumber
    }
    
    // MARK: - Protocols
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return (
            lhs.name == rhs.name
                && lhs.sections == rhs.sections
                && lhs.instructor == rhs.instructor
                && lhs.weekNumber == rhs.weekNumber
        )
    }
}

struct Courses {
    var courses: [Course]!
    var semester: (Int, Int)!
    
    // MARK: - Initializers
    
    init(courses: [Course], semester: (Int, Int)) {
        self.courses = courses
        self.semester = semester
    }
}
