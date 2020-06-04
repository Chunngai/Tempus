//
//  ScheduleNavigationViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ScheduleNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customizes the navigation bar.
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.setToTransparent()
        
        // Customizes the tab bar.
        tabBarItem.title = "Schedule"
    }
}
