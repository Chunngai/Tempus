//
//  Class.swift
//  Tempus
//
//  Created by Sola on 2020/2/6.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation

struct Class_ {
    var courseName: String
    var day: Int
    var sections: [Int]
    var time: (DateComponents, DateComponents) {
        let startTime = Class_.section2Time(sectionNum: sections.first!).start!
        let finishTime = Class_.section2Time(sectionNum: sections.last!).finish!
        
        return (startTime, finishTime)
    }
    var classroom: String
    
    static func section2Time(sectionNum: Int) -> (start: DateComponents?, finish: DateComponents?) {
        var start: DateComponents?
        var finish: DateComponents?
        
        switch sectionNum {
        case 1:
            start = DateComponents(hour: 8, minute: 30)
            finish = DateComponents(hour: 9, minute: 10)
        case 2:
            start = DateComponents(hour: 9, minute: 10)
            finish = DateComponents(hour: 9, minute: 50)
        case 3:
            start = DateComponents(hour: 10, minute: 10)
            finish = DateComponents(hour: 10, minute: 50)
        case 4:
            start = DateComponents(hour: 10, minute: 50)
            finish = DateComponents(hour: 11, minute: 30)
        case 5:
            start = DateComponents(hour: 11, minute: 35)
            finish = DateComponents(hour: 12, minute: 15)
        case 6:
            start = DateComponents(hour: 12, minute: 30)
            finish = DateComponents(hour: 13, minute: 10)
        case 7:
            start = DateComponents(hour: 13, minute: 10)
            finish = DateComponents(hour: 13, minute: 50)
        case 8:
            start = DateComponents(hour: 14, minute: 00)
            finish = DateComponents(hour: 14, minute: 40)
        case 9:
            start = DateComponents(hour: 14, minute: 40)
            finish = DateComponents(hour: 15, minute: 20)
        case 10:
            start = DateComponents(hour: 15, minute: 40)
            finish = DateComponents(hour: 16, minute: 20)
        case 11:
            start = DateComponents(hour: 16, minute: 20)
            finish = DateComponents(hour: 17, minute: 00)
        case 12:
            start = DateComponents(hour: 18, minute: 30)
            finish = DateComponents(hour: 19, minute: 10)
        case 13:
            start = DateComponents(hour: 19, minute: 10)
            finish = DateComponents(hour: 19, minute: 50)
        case 14:
            start = DateComponents(hour: 20, minute: 00)
            finish = DateComponents(hour: 20, minute: 40)
        case 15:
            start = DateComponents(hour: 20, minute: 40)
            finish = DateComponents(hour: 21, minute: 20)
        default:
            start = nil
            finish = nil
        }
        
        return (start, finish)
    }
    
    static var timeTableOfSophomoreSecondSemester = [
        Class_(courseName: "Computer Network", day: Calendar.gregorianShortWeekdaySymbols.mon.rawValue, sections: [1, 2], classroom: "F402"),
        Class_(courseName: "Probability", day: Calendar.gregorianShortWeekdaySymbols.mon.rawValue, sections: [3, 4, 5], classroom: "F202"),
        Class_(courseName: "World Heritage and Tourism Management", day: Calendar.gregorianShortWeekdaySymbols.mon.rawValue, sections: [6, 7], classroom: "F102"),
        
        Class_(courseName: "Movie English", day: Calendar.gregorianShortWeekdaySymbols.tue.rawValue, sections: [3, 4], classroom: "Lab E304"),
        Class_(courseName: "Web Development", day: Calendar.gregorianShortWeekdaySymbols.tue.rawValue, sections: [9, 10, 11], classroom: "Lab C505"),
        
        Class_(courseName: "Computer Network", day: Calendar.gregorianShortWeekdaySymbols.wed.rawValue, sections: [3, 4], classroom: "F402"),
        Class_(courseName: "Database", day: Calendar.gregorianShortWeekdaySymbols.wed.rawValue, sections: [8, 9], classroom: "F511"),
        Class_(courseName: "Badminton", day: Calendar.gregorianShortWeekdaySymbols.wed.rawValue, sections: [10, 11], classroom: "Badminton Court 1"),
        Class_(courseName: "Dialects and Regional Culture", day: Calendar.gregorianShortWeekdaySymbols.wed.rawValue, sections: [12, 13], classroom: "D512"),
        
        Class_(courseName: "Database", day: Calendar.gregorianShortWeekdaySymbols.thu.rawValue, sections: [1, 2], classroom: "F203"),
        Class_(courseName: "Interpretation", day: Calendar.gregorianShortWeekdaySymbols.thu.rawValue, sections: [3, 4], classroom: "Lab E307")
    ]
    
    static func loadTimeTable() -> [Class_]? {
        return nil
    }
    
    static func saveTimeTable() {
        
    }
}

extension Calendar {
    enum gregorianShortWeekdaySymbols: Int {
        case sun = 0
        case mon = 1
        case tue = 2
        case wed = 3
        case thu = 4
        case fri = 5
        case sat = 6
        
        var dayName: String {
            return Calendar(identifier: .gregorian).shortWeekdaySymbols[self.rawValue]
        }
    }
}
