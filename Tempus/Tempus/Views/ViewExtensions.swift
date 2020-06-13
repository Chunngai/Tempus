//
//  ViewExtensions.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
    func setTransparent() {
        self.backgroundImage = UIImage()
        self.shadowImage = UIImage()
    }
}

extension UINavigationBar {
    func setTransparent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension UIColor {
    static var sky = UIColor(red: 0.462, green: 0.838, blue: 1.000, alpha: 1)
    static var aqua = UIColor(red: 0.000, green: 0.590, blue: 1.000, alpha: 1)
}


extension UIView {
    func addGradientLayer(gradientLayer: CAGradientLayer, colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint, frame: CGRect) {
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
    
    func formattedDateAndTime(separator: String = "/", omitZero: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM\(separator)dd hh:mm"
        if omitZero && self.getComponent(.hour).hour! == 0 && self.getComponent(.minute).minute! == 0 {
            dateFormatter.dateFormat = "MM\(separator)dd"
        }
        
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.string(from: self)
    }
    
    func getComponent(identifier: Calendar.Identifier = .gregorian, _ component: Calendar.Component) -> DateComponents {
        return Calendar(identifier: identifier).dateComponents([component], from: Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self))
    }
}

extension DateInterval {
    func formatted(omitZero: Bool = false) -> String {
        func concat(component: Int?, identifier: String) -> String {
            if let component = component {
                if omitZero && component == 0 {
                    return ""
                }
                
                return "\(component)\(identifier) "
            }
            return ""
        }

        let from = Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self.start)
        let to = Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self.end)
        
        let components = Calendar(identifier: .gregorian).dateComponents([.month, .day, .hour, .minute],
                                                                         from: from, to: to)

        return concat(component: components.month, identifier: "M")
            + concat(component: components.day, identifier: "d")
            + concat(component: components.hour, identifier: "h")
            + concat(component: components.minute, identifier: "m")
    }
    
    func getComponent(identifier: Calendar.Identifier = .gregorian, _ component: Calendar.Component) -> DateComponents {
        return Calendar(identifier: identifier).dateComponents([component],
                                                               from: Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self.start),
                                                               to: Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: self.end))
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
