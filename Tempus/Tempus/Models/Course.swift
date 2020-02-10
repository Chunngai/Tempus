//
//  Course.swift
//  Tempus
//
//  Created by Sola on 2020/2/9.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Course {
    var name: String
    var teacher: String
    var lessons: [Lesson]
    var assignments: [Task]
}

extension Course {
    struct Lesson {
        var day: Day
        var time: Time
        var classroom: String
        var comment: String
        var isFinishedThisWeek: Bool
    }
}

