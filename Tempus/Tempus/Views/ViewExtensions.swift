//
//  ViewExtensions.swift
//  Tempus
//
//  Created by Sola on 2020/2/10.
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
    
    static var salmon = UIColor(red: 1.000, green: 0.493, blue: 0.474, alpha: 1)
    static var maraschino = UIColor(red: 1.000, green: 0.149, blue: 0.000, alpha: 1)
    
    static var banana = UIColor(red: 1.000, green: 0.988, blue: 0.473, alpha: 1)
    static var lemon = UIColor(red: 0.999, green: 0.986, blue: 0.000, alpha: 1)
    
    static var flora = UIColor(red: 0.450, green: 0.981, blue: 0.474, alpha: 1)
    static var spring = UIColor(red: 0.000, green: 0.977, blue: 0.000, alpha: 1)
}

extension UIView {
    func addGradientLayer(gradientLayer: CAGradientLayer, colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
