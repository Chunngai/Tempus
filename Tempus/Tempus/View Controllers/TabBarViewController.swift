//
//  TabBarViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK: - Controllers
    
    var scheduleNavigationViewController: ScheduleNavigationViewController!
    var scheduleViewController: ScheduleViewController = ScheduleViewController()
    
    var toDoNavigationViewController: ToDoNavigationViewController!
    var toDoViewController = ToDoViewController()
    
    // MARK: - Views
    
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        // Color of the bar.
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightText
        tabBar.setTransparent()
        
        // Creates a gradient layer.
        self.view.addGradientLayer(gradientLayer: gradientLayer,
                                   colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
                                   locations: [0.0, 1.0],
                                   startPoint: CGPoint(x: 0, y: 1),
                                   endPoint: CGPoint(x: 1, y: 0),
                                   frame: self.view.bounds)
        
        // Creates a navigation controller for schedule, whose root controller is a schedule view controller.
        scheduleNavigationViewController = ScheduleNavigationViewController(rootViewController: scheduleViewController)
        scheduleNavigationViewController.tabBarItem.title = "Schedule"
        self.addChild(scheduleNavigationViewController)
        
        // Creates a navigation controller for todos, whose root controller is a todo view controller.
        toDoNavigationViewController = ToDoNavigationViewController(rootViewController: toDoViewController)
        toDoNavigationViewController.tabBarItem.title = "To Do"
        if let emergentTaskNumber = ToDo.loadToDo()?.emergentTaskNumber {
            // Badge on the tab bar item.
            toDoNavigationViewController.tabBarItem.badgeValue = String(emergentTaskNumber)
            
            // Badge on the app icon.
            let identifier = "identifier"
            let content = UNMutableNotificationContent()
            content.badge = NSNumber(value: emergentTaskNumber)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) {
                error in
            }
        }
        self.addChild(toDoNavigationViewController)
    }
}
