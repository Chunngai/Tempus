//
//  CourseNavigationController.swift
//  Tempus
//
//  Created by Sola on 2020/8/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customizes the navigation bar.        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.setTransparent()
    }
}
