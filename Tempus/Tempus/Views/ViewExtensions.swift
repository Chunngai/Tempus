//
//  ViewExtensions.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func setTransparent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension UITabBar {
    func setTransparent() {
        self.backgroundImage = UIImage()
        self.shadowImage = UIImage()
        self.clipsToBounds = true
    }
}

extension UIColor {
    static var sky = UIColor(red: 0.462, green: 0.838, blue: 1.000, alpha: 1)
    static var aqua = UIColor(red: 0.000, green: 0.590, blue: 1.000, alpha: 1)
}

extension UIView {
    func addGradientLayer(gradientLayer: CAGradientLayer = CAGradientLayer(),
                          colors: [CGColor] = [UIColor.aqua.cgColor, UIColor.sky.cgColor],
                          locations: [NSNumber] = [0.0, 1.0],
                          startPoint: CGPoint = CGPoint(x: 0, y: 1),
                          endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
                          frame: CGRect) {
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.frame = frame

        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}

extension Date {
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.string(from: self)
    }
    
    func formattedDate(separator: String="/") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM\(separator)dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.string(from: self)
    }
    
    func formattedLongDate(separator: String = "/") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy\(separator)MM\(separator)dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.string(from: self)
    }
    
    func formattedDateAndTime(separator: String = "/", omitZero: Bool = false, withWeekday: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        dateFormatter.dateFormat = "MM\(separator)dd"
        timeFormatter.dateFormat = "hh:mm"
        
        var formattedString = dateFormatter.string(from: self)
        if withWeekday {
            formattedString += " \(self.shortWeekdaySymbol)"
        }
        if !(omitZero && self.getComponents([.hour]).hour! == 0 && self.getComponents([.minute]).minute! == 0) {
            formattedString += " " + timeFormatter.string(from: self)
        }
        
        return formattedString
    }
    
    var shortWeekdaySymbol: String {
        let calendar = Calendar(identifier: .gregorian)  // Timezone of the date generated is according to the system.
        let gmtDate = Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self)
        
        let weekday = calendar.component(.weekday, from: gmtDate)
        return calendar.shortWeekdaySymbols[weekday - 1]
    }
    
    func getComponents(identifier: Calendar.Identifier = .gregorian, _ components: Set<Calendar.Component>) -> DateComponents {
        let from = Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self)
        
        return Calendar(identifier: identifier).dateComponents(components, from: from)
    }
}

extension DateInterval {
    func formatted(omitZero: Bool = false) -> String {
        func concat(component: Int?, identifier: String) -> String {
            if omitZero && component! == 0 {
                return ""
            } else {
                return "\(component!)\(identifier) "
            }
        }

        let components = getComponents([.month, .day, .hour])
        let formattedString = concat(component: components.month, identifier: "M")
            + concat(component: components.day, identifier: "d")
            + concat(component: components.hour, identifier: "h")
        
        if !formattedString.isEmpty {
            return formattedString
        } else {
            return "0 h"
        }
    }
    
    func getComponents(identifier: Calendar.Identifier = .gregorian, _ components: Set<Calendar.Component>) -> DateComponents {
        let from = Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self.start)
        let to = Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self.end)
        
        return Calendar(identifier: identifier).dateComponents(components, from: from, to: to)
    }
}

extension TimeInterval {
    func formattedDuration() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) % 3600 / 60
        
        var formattedString = ""
        if hours != 0 {
            formattedString += "\(hours)h"
        }
        if minutes != 0 {
            formattedString += " \(minutes)m"
        }
        
        return formattedString
    }
}
