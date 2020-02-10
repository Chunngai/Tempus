//
//  Timetable.swift
//  Tempus
//
//  Created by Sola on 2020/2/9.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Timetable {
    var semester: Semester
    var lessons: [Course.Lesson]
}

extension Timetable {
    static var timeTableSections: [Int: Time]?
}
