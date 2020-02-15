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

extension Course {
    var dueDateNotBeforeTodayAndFinishedAssignmentNumber: Int {
        var dueDateNotBeforeTodayAndFinishedAssignmentNumber = 0
        
        for assignment in self.assignments {
            if assignment.dateInterval.end >= Date() && assignment.isFinished {
                dueDateNotBeforeTodayAndFinishedAssignmentNumber += 1
            }
        }
        
        return dueDateNotBeforeTodayAndFinishedAssignmentNumber
    }
    
    var dueDateNotBeforeTodayOrUnfinishedAssignmentNumber: Int {
        var dueDateNotBeforeTodayOrUnfinishedAssignmentNumber = 0
        
        for assignment in self.assignments {
            if !(assignment.dateInterval.end < Date() && assignment.isFinished) {
                dueDateNotBeforeTodayOrUnfinishedAssignmentNumber += 1
            }
        }
        
        return dueDateNotBeforeTodayOrUnfinishedAssignmentNumber
    }
    
    var availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber: Int {
        var availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber = 0
        
        for assignment in self.assignments {
            if !assignment.isFinished, assignment.availableTime.month! == 0, assignment.availableTime.day! <= 3 {
                availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber += 1
            }
        }
        
        return availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber
    }
    
    mutating func sortAssignmentsByDueDateAndTimeAvailable() {
        var dueDateBeforeTodayAndFinishedAssignments: [Task] = []
        var dueDateNotBeforeTodayOrUnfinishedAssignments: [Task] = []

        var unfinishedAssignmentNumber = 0
        for assignment in self.assignments {
            if assignment.dateInterval.end < Date() && assignment.isFinished {
                dueDateBeforeTodayAndFinishedAssignments.append(assignment)
            } else {
                if assignment.isFinished {
                    dueDateNotBeforeTodayOrUnfinishedAssignments.append(assignment)
                } else {
                    dueDateNotBeforeTodayOrUnfinishedAssignments.insert(assignment, at: 0)
                    unfinishedAssignmentNumber += 1
                }
            }
        }
        
        dueDateNotBeforeTodayOrUnfinishedAssignments[0..<unfinishedAssignmentNumber].sort { $0.availableTime.minutes < $1.availableTime.minutes }
        
        let assignments = dueDateNotBeforeTodayOrUnfinishedAssignments + dueDateBeforeTodayAndFinishedAssignments
        self.assignments = assignments
    }
}

extension Array where Element == Course {
    var totalDueDateNotBeforeTodayAndFinishedAssignmentNumber: Int {
        var dueDateNotBeforeTodayAndFinishedAssignmentNumber = 0
        
        for course in self {
            dueDateNotBeforeTodayAndFinishedAssignmentNumber += course.dueDateNotBeforeTodayAndFinishedAssignmentNumber
        }
        
        return dueDateNotBeforeTodayAndFinishedAssignmentNumber
    }
    var totalDueDateNotBeforeTodayOrUnfinishedAssignmentNumber : Int {
        var dueDateNotBeforeTodayOrUnfinishedAssignmentNumber = 0
    
        for course in self {
            dueDateNotBeforeTodayOrUnfinishedAssignmentNumber += course.dueDateNotBeforeTodayOrUnfinishedAssignmentNumber
        }
        
        return dueDateNotBeforeTodayOrUnfinishedAssignmentNumber
    }
    var totalAvailableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber: Int {
        var availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber = 0
        
        for course in self {
            availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber += course.availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber
        }
        
        return availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber
    }
}

//extension Array where Element == Course {
//    var activeCourseIndices: [[Int]] {
//        var activeCourseIndices: [[Int]] = []
//
//        var lastArrayIndex = 0
//        for courseIndex in 0..<self.count {
//            activeCourseIndices.append([])
//
//            let courseAssignments = self[courseIndex].assignments
//            for assignmentIndex in 0..<courseAssignments.count {
//                let assignment = self[courseIndex].assignments[assignmentIndex]
//
//                if assignment.dateInterval.end > Date()
//                    || (assignment.dateInterval.end < Date() && assignment.isFinished == false) {
//                    activeCourseIndices[lastArrayIndex].append(assignmentIndex)
//                }
//            }
//            lastArrayIndex += 1
//        }
//        
//        return activeCourseIndices
//    }
//}

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
        
        let cpp1 = Task(content: "chapter 1 exercises 1, use as many ways as possible. refer to the related sections in the textbook and related resources on the website.", dateInterval: DateInterval(start: date - 60 * 60 * 24 * 6, duration: 60*60*24 * 3), isFinished: false, category: ["Course": "C++"])
        cpp.assignments.append(cpp1)
        
        let cpp2 = Task(content: "chapter 2 exercises 1, use as many ways as possible. refer to the related sections in the textbook and related resources on the website.", dateInterval: DateInterval(start: date, duration: 60*60*10), isFinished: false, category: ["Course": "C++"])
        cpp.assignments.append(cpp2)
        
        let cpp3 = Task(content: "chapter 3 exercises 1, use as many ways as possible. refer to the related sections in the textbook and related resources on the website.", dateInterval: DateInterval(start: Date(), duration: 60*60*3), isFinished: false, category: ["Course": "C++"])
        cpp.assignments.append(cpp3)
        
        let cpp4 = Task(content: "chapter 4 exercises 1, use as many ways as possible. refer to the related sections in the textbook and related resources on the website.", dateInterval: DateInterval(start: date, duration: 60*60*60 * 2), isFinished: false, category: ["Course": "C++"])
        cpp.assignments.append(cpp4)
        
        let cpp5 = Task(content: "chapter 5 exercises 1, use as many ways as possible. refer to the related sections in the textbook and related resources on the website.", dateInterval: DateInterval(start: date, duration: 60*60*60 * 3), isFinished: true, category: ["Course": "C++"])
        cpp.assignments.append(cpp5)
        
        let cpp6 = Task(content: "chapter 6 exercise all", dateInterval: DateInterval(start: date, end: date + 1), isFinished: true, category: ["Course": "C++"])
        cpp.assignments.append(cpp6)
        
        let cpp7 = Task(content: "chapter 7 exercise all", dateInterval: DateInterval(start: date, end: date + 61), isFinished: true, category: ["Course": "C++"])
        cpp.assignments.append(cpp7)
        
        let cpp8 = Task(content: "chapter 8 exercise all", dateInterval: DateInterval(start: date, end: date + 60), isFinished: true, category: ["Course": "C++"])
        cpp.assignments.append(cpp8)
        
        let java1 = Task(content: "ch 3: 1, 2", dateInterval: DateInterval(start: date, duration: 60*60 * 50), isFinished: false, category: ["Course": "Java"])
        java.assignments.append(java1)
        
        let python1 = Task(content: "machine learning linear regression derivation", dateInterval: DateInterval(start: date, duration: 60*60*200), isFinished: false, category: ["Course": "Python"])
        python.assignments.append(python1)
        
        let python2 = Task(content: "deep learning convolutional network derivation", dateInterval: DateInterval(start: Date(), duration: 60 * 60 * 24 * 33), isFinished: true, category: ["Course": "Python"])
        python.assignments.append(python2)
        
        return [cpp, java, python]
    }
}
