//
//  Schedule.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Schedule: Codable {
    // Vars.
    var date: Date
    var tasks: [Task]
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
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
    static func loadSchedule(date: Date) -> Schedule? {
//        print(date.formattedDate(), date.formattedTime(), 0)
        let archiveURL = DocumentsDirectory.appendingPathComponent("schedule \(date.formattedDate())").appendingPathExtension("plist")
        
        guard let codedSchedule = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Schedule.self, from: codedSchedule)
    }
    
    static func saveSchedule(_ schedule: Schedule) {
//        print(schedule.date.formattedDate(), schedule.date.formattedTime(), 1)
        let archiveURL = DocumentsDirectory.appendingPathComponent("schedule \(schedule.date.formattedDate())").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let codedSchedule = try? propertyListEncoder.encode(schedule)
        try? codedSchedule?.write(to: archiveURL, options: .noFileProtection)
    }
}
