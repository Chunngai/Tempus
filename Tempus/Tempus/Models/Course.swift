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
    var instructor: String
    var lessons: [Lesson]
    var assignments: [Task]
    
    static func loadCourses() -> [Course]? {
        return nil
    }
    
    static func saveCourses() {
        
    }
}

extension Course {
    struct Lesson {
        var day: Day
        var time: Date
        var location: String
        var comment: String
        var isFinishedThisWeek: Bool
    }
}

extension Array where Element == Course {
    var activeCourseIndices: [[Int]] {
        var activeCourseIndices: [[Int]] = []
        
        var lastArrayIndex = 0
        for courseIndex in 0..<self.count {
            activeCourseIndices.append([])
            
            let courseAssignments = self[courseIndex].assignments
            for assignmentIndex in 0..<courseAssignments.count {
                let assignment = self[courseIndex].assignments[assignmentIndex]
                
                if assignment.dateInterval.end > Date()
                    || (assignment.dateInterval.end < Date() && assignment.isFinished == false) {
                    activeCourseIndices[lastArrayIndex].append(assignmentIndex)
                }
            }
            lastArrayIndex += 1
        }
        
        return activeCourseIndices
    }
}

let date = Date() - 60*60*30
extension Course {
    static var sampleCourses: [Course] {
        var cpp = Course(name: "C++", instructor: "Cpp instructor", lessons: [
            Lesson(day: .mon, time: Date(), location: "cpp location", comment: "cpp comment", isFinishedThisWeek: false)
        ], assignments: [])
        
        var java = Course(name: "Java", instructor: "Java instructor", lessons: [
            Lesson(day: .tue, time: Date(), location: "java location", comment: "java comment", isFinishedThisWeek: false)
        ], assignments: [])
        
        var python = Course(name: "Python", instructor: "Python instructor", lessons: [
            Lesson(day: .fri, time: Date(), location: "python location", comment: "python comment", isFinishedThisWeek: true)
        ], assignments: [])
        
        let cpp1 = Task(content: "chapter 3 exercises 1, 2", dateInterval: DateInterval(start: Date(), duration: 60*60*60), isOverDue: true, isFinished: false, category: ["Course": "C++"])
        cpp.assignments.append(cpp1)
        
        let cpp2 = Task(content: "chapter 10 exercise all", dateInterval: DateInterval(start: date, end: date + 1), isOverDue: false, isFinished: true, category: ["Course": "C++"])
        cpp.assignments.append(cpp2)
        
        let java1 = Task(content: "ch 3: 1, 2", dateInterval: DateInterval(start: Date(), duration: 60*60*60), isOverDue: false, isFinished: true, category: ["Course": "Java"])
        java.assignments.append(java1)
        
        let python1 = Task(content: "machine learning linear regression derivation", dateInterval: DateInterval(start: Date(), duration: 60*60*200), isOverDue: false, isFinished: true, category: ["Course": "Python"])
        python.assignments.append(python1)
        
        let python2 = Task(content: "deep learning convolutional network derivation", dateInterval: DateInterval(start: Date(), duration: 60 * 60 * 60), isOverDue: true, isFinished: true, category: ["Course": "Python"])
        python.assignments.append(python2)
        
        return [cpp, java, python]
    }
}
