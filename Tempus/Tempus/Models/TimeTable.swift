//
//  TimeTable.swift
//  Tempus
//
//  Created by Sola on 2020/8/23.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct TimeTable: Codable {
    var sections: [Section]!
    var semester: (grade: Int, half: Int)!
    var isCurrent: Bool!
    {
        didSet {
            if self.isCurrent {
                for grade in 1...4 {
                    for half in [1, 2] {
                        let semesterOfAnotherCourses = (grade: grade, half: half)
                        if semesterOfAnotherCourses != semester {
                            var anotherCourses = TimeTable.loadCourses(semester: semesterOfAnotherCourses)!
                            anotherCourses.isCurrent = false
                            TimeTable.saveCourses(anotherCourses)
                        }
                    }
                }
            }
        }
    }
    
    static var semesterTexts = [
        1: "Freshman",
        2: "Sophomore",
        3: "Junior",
        4: "Senior"
    ]
        
    // MARK: - Initializers
    
    init(sections: [Section], semester: (grade: Int, half: Int), isCurrent: Bool) {
        self.sections = sections
        self.semester = semester
        self.isCurrent = isCurrent
    }
    
    // MARK: - Protocols
    
    enum CodingKeys: CodingKey {  // Should consider EVERY property.
        case sections, grade, half, isCurrent
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sections, forKey: .sections)
        
        try container.encode(semester.grade, forKey: .grade)
        try container.encode(semester.half, forKey: .half)
        
        try container.encode(isCurrent, forKey: .isCurrent)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sections = try container.decode([Section].self, forKey: .sections)
        semester = (
            try container.decode(Int.self, forKey: .grade),
            try container.decode(Int.self, forKey: .half)
        )
        isCurrent = try container.decode(Bool.self, forKey: .isCurrent)
    }
    
    // MARK: - Loading and saving data
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadCourses(semester: (grade: Int, half: Int)) -> TimeTable? {
        let archiveURL = DocumentsDirectory.appendingPathComponent("courses \(semesterTexts[semester.grade]!) \(semester.half == 1 ? "1st" : "2nd")").appendingPathExtension("plist")

        guard let codedCourses = try? Data(contentsOf: archiveURL) else {
            print("failed")
            return TimeTable(sections: [], semester: (grade: semester.grade, half: semester.half), isCurrent: true)
        }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(TimeTable.self, from: codedCourses)
    }
    
    static func saveCourses(_ courses: TimeTable) {
        let archiveURL = DocumentsDirectory.appendingPathComponent("courses \(semesterTexts[courses.semester.grade]!) \(courses.semester.half == 1 ? "1st" : "2nd")").appendingPathExtension("plist")

        let propertyListEncoder = PropertyListEncoder()
        let codedCourses = try? propertyListEncoder.encode(courses)
        try? codedCourses?.write(to: archiveURL, options: .noFileProtection)
    }
}
