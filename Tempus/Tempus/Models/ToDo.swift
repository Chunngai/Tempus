//
//  ToDo.swift
//  Tempus
//
//  Created by Sola on 2020/3/28.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct ToDo: Codable {
    var category: String
    var tasks: [Task]
   
    // MARK: - Loading and saving data
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    static func loadToDo() -> [ToDo]? {
        let archiveURL = DocumentsDirectory.appendingPathComponent("todo").appendingPathExtension("plist")

        guard let codedToDo = try? Data(contentsOf: archiveURL) else {
            return [ToDo(category: "Default",
                         tasks: [Task(content: "default task",
                                      dateInterval: Interval(start: Date().currentTimeZone(), duration: 3600),
                                      isFinished: false,
                                      category: "Default")])]
        }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([ToDo].self, from: codedToDo)
    }

    static func saveToDo(_ toDo: [ToDo]) {
        let archiveURL = DocumentsDirectory.appendingPathComponent("todo").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let codedToDo = try? propertyListEncoder.encode(toDo)
        try? codedToDo?.write(to: archiveURL, options: .noFileProtection)
    }
}
