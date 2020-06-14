//
//  ToDoNavigationViewController.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizes the navigation bar.
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.setTransparent()
        
        // Customizes the tab bar.
        tabBarItem.title = "To Do"
    }
}
