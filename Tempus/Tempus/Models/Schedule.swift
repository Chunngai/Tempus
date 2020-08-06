//
//  Schedule.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Schedule: Codable {
    var date: Date  // GMT 8.
    var tasks: [Task]
    var committed: Bool?
    
    // MARK: - Loading and saving data
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadSchedule(date: Date) -> Schedule? {
        let archiveURL = DocumentsDirectory.appendingPathComponent("schedule \(date.archiveURLDateComponent())").appendingPathExtension("plist")

        guard let codedSchedule = try? Data(contentsOf: archiveURL) else {
            return Schedule(date: date, tasks: [Task](), committed: false)
        }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Schedule.self, from: codedSchedule)
    }
    
    static func saveSchedule(_ schedule: Schedule) {
        let archiveURL = DocumentsDirectory.appendingPathComponent("schedule \(schedule.date.archiveURLDateComponent())").appendingPathExtension("plist")

        let propertyListEncoder = PropertyListEncoder()
        let codedSchedule = try? propertyListEncoder.encode(schedule)
        try? codedSchedule?.write(to: archiveURL, options: .noFileProtection)
    }
}
        
extension Date {
    func archiveURLDateComponent() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.string(from: self)
    }
}
