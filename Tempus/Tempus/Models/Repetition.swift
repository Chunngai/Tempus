//
//  Repetition.swift
//  Tempus
//
//  Created by Sola on 2020/8/1.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Repetition: Codable {
    var repetitionInterval: RepetitionInterval
    var lastDate: Date
    var repeatTueDate: Date
    
    var number: Int {
        switch repetitionInterval {
        case .day(number: let number):
            return number
        case .week(number: let number):
            return number
        case .month(number: let number):
            return number
        }
    }
    
    var intervalIdx: Int {
        switch repetitionInterval {
        case .day(number: _):
            return 0
        case .week(number: _):
            return 1
        case .month(number: _):
            return 2
        }
    }
    
    var formattedRepeatTilDate: String {
        return "Til \(repeatTueDate.formattedDate())"
    }
    
    static var numbers = [1..<366, 1..<53, 1..<13]
    static var intervals = ["Day", "Week", "Month"]

    // MARK: - Initializers

    init(repetitionInterval: RepetitionInterval = .week(number: 1), lastDate: Date = Date().currentTimeZone(), repeatTueDate: Date = Date(timeInterval: 7 * 3600, since: Date().currentTimeZone())) {
        self.repetitionInterval = repetitionInterval
        self.lastDate = lastDate
        self.repeatTueDate = repeatTueDate
    }
    
    init(repetition: (number: Int, intervalIdx: Int), lastDate: Date = Date().currentTimeZone(), repeatTueDate: Date = Date(timeInterval: 7 * 3600, since: Date().currentTimeZone())) {
        if repetition.intervalIdx == 0 {
            self.repetitionInterval = .day(number: repetition.number)
        } else if repetition.intervalIdx == 1 {
            self.repetitionInterval = .week(number: repetition.number)
        } else {
            self.repetitionInterval = .month(number: repetition.number)
        }
        self.lastDate = lastDate
        self.repeatTueDate = repeatTueDate
    }
    
    // MARK: - Protocols
    
    enum CodingKeys: CodingKey {
        case interval, number, lastDate, repeatTueDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch repetitionInterval {
        case .day(number: let number):
            try container.encode("day", forKey: .interval)
            try container.encode(number, forKey: .number)
        case .week(number: let number):
            try container.encode("week", forKey: .interval)
            try container.encode(number, forKey: .number)
        case .month(number: let number):
            try container.encode("month", forKey: .interval)
            try container.encode(number, forKey: .number)
        }
        
        try container.encode(lastDate, forKey: .lastDate)
        try container.encode(repeatTueDate, forKey: .repeatTueDate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let interval = try container.decode(String.self, forKey: .interval)
        let number = try container.decode(Int.self, forKey: .number)
        if interval == "day" {
            repetitionInterval = RepetitionInterval.day(number: number)
        } else if interval == "week" {
            repetitionInterval = RepetitionInterval.week(number: number)
        } else {
            repetitionInterval = RepetitionInterval.month(number: number)
        }
        
        lastDate = try container.decode(Date.self, forKey: .lastDate)
        repeatTueDate = try container.decode(Date.self, forKey: .repeatTueDate)
    }

    // MARK: - Customized funcs

    func next() -> Date {
        switch repetitionInterval {
        case .day(let dayNumber):
            return next(dayNumber, .day)
        case .week(let weekNumber):
            return next(weekNumber * 7, .day)
        case .month(let monthNumber):
            return next(monthNumber, .month)
        }
    }

    func next(_ value: Int, _ component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: lastDate)!
    }
    
//    func formatted() -> String {
//        var text = "Every "
//        var number_: Int
//        
//        switch repetitionInterval {
//        case .day(number: let number):
//            text += "\(number) Day"
//            number_ = number
//        case .week(number: let number):
//            text += "\(number) Week"
//            number_ = number
//        case .month(number: let number):
//            text += "\(number) Month"
//            number_ = number
//        }
//        
//        if number_ > 1 {
//            text += "s"
//        }
//        
//        return text
//    }
    
    mutating func updateRepetitionInterval(number: Int, intervalIdx: Int) {
        if intervalIdx == 0 {
            self.repetitionInterval = .day(number: number)
        } else if intervalIdx == 1 {
            self.repetitionInterval = .week(number: number)
        } else {
            self.repetitionInterval = .month(number: number)
        }
    }
    
    mutating func updateRepetitionRepeatTueDate(repeatTilDate: Date) {
        self.repeatTueDate = repeatTilDate
    }
    
    static func formatted(repetition: Repetition?) -> String {
        if repetition == nil {
            return "Never"
        }
        
        var text = "Every \(repetition!.number) \(intervals[repetition!.intervalIdx])"
        if repetition!.number > 1 {
            text += "s"
        }
        
        return text
    }
}

enum RepetitionInterval {
    case day(number: Int)
    case week(number: Int)
    case month(number: Int)
}
