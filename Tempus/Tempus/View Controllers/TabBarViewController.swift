//
//  TabBarViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    var scheduleNavigationViewController: ScheduleNavigationViewController?
    var scheduleViewController: ScheduleViewController = ScheduleViewController()
    
    var toDoNavigationViewController: ToDoNavigationViewController?
    var toDoViewController = ToDoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Color of the bar.
        tabBar.barTintColor = UIColor.aqua.withAlphaComponent(0)
        tabBar.alpha = 0.5
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightText
        
        // Creates a gradient layer.
        self.view.addGradientLayer(gradientLayer: gradientLayer,
                                   colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
                                   locations: [0.0, 1.0],
                                   startPoint: CGPoint(x: 0, y: 1),
                                   endPoint: CGPoint(x: 1, y: 0),
                                   frame: self.view.bounds)
        
        // Creates a navigation controller for schedule, whose root controller is a schedule view controller.
        scheduleNavigationViewController = ScheduleNavigationViewController(rootViewController: scheduleViewController)
        if let scheduleNavigationViewController = scheduleNavigationViewController {
            self.addChild(scheduleNavigationViewController)
        }
        
        // Creates a navigation controller for todos, whose root controller is a todo view controller.
        toDoNavigationViewController = ToDoNavigationViewController(rootViewController: toDoViewController)
        if let toDoNavigationViewController = toDoNavigationViewController {
            self.addChild(toDoNavigationViewController)
        }
    }
}
