//
//  Course.swift
//  Tempus
//
//  Created by Sola on 2020/8/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Course: Equatable, Codable {
    var name: String!
    var instructor: String!
    var weekNumber: Int!
    var sections: [Section]!
    
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

struct Courses: Codable {
    var courses: [Course]!
    var semester: (grade: Int, half: Int)!
    var isCurrent: Bool!
    {
        didSet {
            if self.isCurrent {
                for grade in 1...4 {
                    for half in [1, 2] {
                        let semesterOfAnotherCourses = (grade: grade, half: half)
                        if semesterOfAnotherCourses != semester {
                            var anotherCourses = Courses.loadCourses(semester: semesterOfAnotherCourses)!
                            anotherCourses.isCurrent = false
                            Courses.saveCourses(anotherCourses)
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
    
    init(courses: [Course], semester: (grade: Int, half: Int), isCurrent: Bool) {
        self.courses = courses
        self.semester = semester
        self.isCurrent = isCurrent
    }
    
    // MARK: - Protocols
    
    enum CodingKeys: CodingKey {  // Should consider EVERY property.
        case courses, grade, half, isCurrent
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(courses, forKey: .courses)
        
        try container.encode(semester.grade, forKey: .grade)
        try container.encode(semester.half, forKey: .half)
        
        try container.encode(isCurrent, forKey: .isCurrent)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        courses = try container.decode([Course].self, forKey: .courses)
        semester = (
            try container.decode(Int.self, forKey: .grade),
            try container.decode(Int.self, forKey: .half)
        )
        isCurrent = try container.decode(Bool.self, forKey: .isCurrent)
    }
    
    // MARK: - Loading and saving data
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadCourses(semester: (grade: Int, half: Int)) -> Courses? {
        let archiveURL = DocumentsDirectory.appendingPathComponent("courses \(semesterTexts[semester.grade]!) \(semester.half == 1 ? "1st" : "2nd")").appendingPathExtension("plist")

        guard let codedCourses = try? Data(contentsOf: archiveURL) else {
            print("failed")
            return Courses(courses: [], semester: (grade: semester.grade, half: semester.half), isCurrent: true)
        }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Courses.self, from: codedCourses)
    }
    
    static func saveCourses(_ courses: Courses) {
        let archiveURL = DocumentsDirectory.appendingPathComponent("courses \(semesterTexts[courses.semester.grade]!) \(courses.semester.half == 1 ? "1st" : "2nd")").appendingPathExtension("plist")

        let propertyListEncoder = PropertyListEncoder()
        let codedCourses = try? propertyListEncoder.encode(courses)
        try? codedCourses?.write(to: archiveURL, options: .noFileProtection)
    }
}
