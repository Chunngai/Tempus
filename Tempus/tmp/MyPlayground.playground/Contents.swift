import UIKit
import Foundation

let myCalendar = Calendar(identifier: .gregorian)
let ymd = myCalendar.dateComponents([.year, .month, .day, .weekday], from: Date())

print(ymd.year, ymd.month, ymd.day, ymd.weekday)
