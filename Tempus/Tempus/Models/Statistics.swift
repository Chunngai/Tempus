//
//  Statistics.swift
//  Tempus
//
//  Created by Sola on 2020/2/9.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Statistics {
    var CompletionStatistics: (
        finishedTasksNumber: Int,
        notFinishedTasksNumber: Int
    )
    
    var CategoryStatistics: [String: [String: DateComponents]]
}
