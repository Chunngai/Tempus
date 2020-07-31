//
//  ScheduleDetailNavigationViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/21.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ScheduleEditNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customizes the navigation bar.
        navigationBar.setTransparent()
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
