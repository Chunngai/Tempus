//
//  Assignment.swift
//  Tempus
//
//  Created by Sola on 2020/2/8.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Assignment {
    var content: String
    var courseName: String
    var dueDate: Date
    var isFinished: Bool
    
    var dueDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: dueDate)
    }
    
    static var assignmentSamples = [
        Assignment(content: "ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1ChineseTaskContent1", courseName: "Chinese", dueDate: Date(), isFinished: false),
        Assignment(content: "ChinsesTaskContent2", courseName: "Chinese", dueDate: Date(), isFinished: false),
        Assignment(content: "MathsTaskContent1", courseName: "Maths", dueDate: Date(), isFinished: false),
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
}
