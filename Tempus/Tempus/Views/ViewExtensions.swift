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
}
