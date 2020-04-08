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
    func setToTransparent() {
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
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.string(from: self)
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