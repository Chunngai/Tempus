//
//  CourseEditNavigationController.swift
//  Tempus
//
//  Created by Sola on 2020/8/22.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseEditNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customizes the navigation bar.
        navigationBar.setTransparent()
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addGradientLayer(frame: self.view.bounds)
    }
}
