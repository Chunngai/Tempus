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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Color of the bar.
//        tabBar.barTintColor = UIColor.sky.withAlphaComponent(0)
        
        // Makes the bar transparent.
        tabBar.alpha = 0
        
        // Creates a gradient layer.
        self.view.addGradientLayer(gradientLayer: gradientLayer,
                                   colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
                                   locations: [0.0, 1.0],
                                   startPoint: CGPoint(x: 0, y: 1),
                                   endPoint: CGPoint(x: 1, y: 0.5),
                                   frame: self.view.bounds)
        
        // Creates a navigation controller for schedule, whose root controller is a schedule view controller.
        scheduleNavigationViewController = ScheduleNavigationViewController(rootViewController: scheduleViewController)
        self.addChild(scheduleNavigationViewController!)
    }
}
