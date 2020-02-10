//
//  Task.swift
//  Tempus
//
//  Created by Sola on 2020/2/9.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Task {
    var content: String
    var start: Date
    var due: Date
    var remainingTime: Date
    var isOverDue: Bool
    var isFinished: Bool
    var repetition: Repetition
    var category: String
}

extension Task {
    enum Repetition {
        case daily
        case weekly
        case monthly
    }
}
