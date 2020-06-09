//
//  ToDo.swift
//  Tempus
//
//  Created by Sola on 2020/3/28.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct ToDo: Codable {
    var cls: String
    var tasks: [Task]
   
    // Loading and saving data.
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    static func loadToDo() -> [ToDo]? {
        let archiveURL = DocumentsDirectory.appendingPathComponent("todo").appendingPathExtension("plist")

        guard let codedToDo = try? Data(contentsOf: archiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([ToDo].self, from: codedToDo)
    }

    static func saveToDo(_ toDo: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDo = try? propertyListEncoder.encode(toDo)
        let archiveURL = DocumentsDirectory.appendingPathComponent("todo").appendingPathExtension("plist")
        try? codedToDo?.write(to: archiveURL, options: .noFileProtection)
    }
}
