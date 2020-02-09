//
//  Assignment.swift
//  Tempus
//
//  Created by Sola on 2020/2/8.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Assignment: Equatable {
    var content: String
    var courseName: String
    var dueDate: Date
    var status: Bool
    
    var dueDateString: String {
        return dueDate.shortStyleString
    }
    
    static var assignmentSamples = [
        Assignment(content: "Computer Network Task Content 1", courseName: "Computer Network", dueDate: Date(), status: false),
        Assignment(content: "Computer Network Task Content 2", courseName: "Computer Network", dueDate: Date(), status: false),
        Assignment(content: "Probability Task Content 1", courseName: "Probability", dueDate: Date(), status: true),
    ]
    
    static func loadAssignments() -> [Assignment]? {
        return nil
    }
    
    static func saveAssignments() {
        
    }
}

extension Array where Element == Assignment {
    var assignmentDict: [String: [Assignment]] {
        var assignmentDict: [String: [Assignment]] = [:]
        
        for assignment in self {
            if assignmentDict.keys.contains(assignment.courseName) {
                assignmentDict[assignment.courseName]!.append(assignment)
            } else {
                assignmentDict[assignment.courseName] = [assignment]
            }
        }
        
        return assignmentDict
    }
    
    var assignmentDictArray: [(courseName: String, assignments: [Assignment])] {
        var assignmentDictArray: [(courseName: String, assignments: [Assignment])] = []
        
        for (courseName, assignments) in self.assignmentDict {
            assignmentDictArray.append((courseName: courseName, assignments: assignments))
        }
        
        return assignmentDictArray.sorted { $0.courseName < $1.courseName }
    }
    
    func firstIndex(with indexPathForSelectedRow: IndexPath) -> Int? {
        let index = self.firstIndex { (assignment) -> Bool in
            assignment == self.assignmentDictArray[indexPathForSelectedRow.section].assignments[indexPathForSelectedRow.row]
        }
        
        return index
    }
}

extension Date {
    var shortStyleString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: self)
    }
}
