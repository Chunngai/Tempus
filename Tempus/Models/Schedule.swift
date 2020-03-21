//
//  Schedule.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Schedule {
    // Vars.
    var date: Date
    var tasks: [Task]
    
    static var sampleSchedule: Schedule {
        return Schedule(date: Date(), tasks: [
            Task(content: "leetcode",
                 dateInterval: DateInterval(start: Date(hour: 8, minute: 30),
                                            end: Date(hour: 8, minute: 50)),
                 isFinished: true),
            Task(content: "prob",
                 dateInterval: DateInterval(start: Date(hour: 9, minute: 00),
                                            end: Date(hour: 9, minute: 40)),
                 isFinished: true),
            Task(content: "take a resttake a resttake a resttake a resttake a resttake a rest",
                 dateInterval: DateInterval(start: Date(hour: 9, minute: 40),
                                            end: Date(hour: 9, minute: 50)),
                 isFinished: true),
            Task(content: "prob",
                 dateInterval: DateInterval(start: Date(hour: 9, minute: 50),
                                            end: Date(hour: 10, minute: 50)),
                 isFinished: true),
            Task(content: "take a rest", dateInterval:
                DateInterval(start: Date(hour: 10, minute: 50), end: Date(hour: 11, minute: 00)),
                 isFinished: false),
            Task(content: "db",
                 dateInterval: DateInterval(start: Date(hour: 11, minute: 00),
                                            end: Date(hour: 11, minute: 40)),
                 isFinished: true),
            Task(content: "db",
                 dateInterval: DateInterval(start: Date(hour: 11, minute: 40),
                                            end: Date(hour: 12, minute: 20)),
                 isFinished: true)
        ])
    }
    
    // Methods.
    static func loadSchedule() -> Schedule? {
        return nil
    }
}
