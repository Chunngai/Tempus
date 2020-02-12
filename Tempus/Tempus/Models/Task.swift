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
    var dateInterval: DateInterval
    var remainingTime: DateComponents {
        return dateInterval.MMddhhmmGregorianDayComponents(start: Date(), end: dateInterval.end)
    }
    var isOverDue: Bool
    var isFinished: Bool
    var repetition: Repetition?
    var category: [String: String]
}

extension Task {
    enum Repetition {
        case day(Int)
        case week(Int)
        case month(Int)
    }
    
    var totalTime: DateComponents {
        return dateInterval.MMddhhmmGregorianDayComponents(start: dateInterval.start, end: dateInterval.end)
    }
}

extension Date {
    var shortDateTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        
        return dateFormatter.string(from: self)
    }
}

extension DateInterval {
    func MMddhhmmGregorianDayComponents(start: Date, end: Date) -> DateComponents {
        let components: Set<Calendar.Component> = [Calendar.Component.month, .day, .hour, .minute]
        return Calendar(identifier: .gregorian).dateComponents(components, from: start, to: end)
    }
}

extension DateComponents {
    var shortString: String {
        var shortString = ""
        
        let dateComponents = [self.month, self.day, self.hour, self.minute]
        for dateComponentIndex in 0..<dateComponents.count {
            if let dateComponent = dateComponents[dateComponentIndex],
                dateComponent != 0 {
                shortString.append(contentsOf: String(dateComponent))
                
                switch dateComponentIndex {
                case 0:
                    shortString.append(contentsOf: "M ")
                case 1:
                    shortString.append(contentsOf: "d ")
                case 2:
                    shortString.append(contentsOf: "h ")
                case 3:
                    shortString.append(contentsOf: "m ")
                default:
                    break
                }
            }
        }
        
        return shortString
    }
    
    var hours: Int {
        return (self.month! * 30 * 24 + self.day! * 24 + self.hour!)
    }
}
