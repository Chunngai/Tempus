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
    
    var courseNavigationController: CourseNavigationController!
    var courseViewController = CourseViewController()
    
    var scheduleNavigationController: ScheduleNavigationController!
    var scheduleViewController: ScheduleViewController = ScheduleViewController()
    
    var toDoNavigationController: ToDoNavigationController!
    var toDoViewController = ToDoViewController()
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        updateControllers()
    }
    
    func updateViews() {
        // Color of the bar.
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightText
        tabBar.setTransparent()
        
        // Creates a gradient layer.
        self.view.addGradientLayer(endPoint: CGPoint(x: 1, y: 0),
                                   frame: self.view.bounds)
    }
    
    func updateControllers() {
        // Creates a navigation controller for courses, whose root controller is a course view controller.
        courseNavigationController = CourseNavigationController(rootViewController: courseViewController)
        courseNavigationController.tabBarItem.title = "Course"
        self.addChild(courseNavigationController)
        
        // Creates a navigation controller for schedule, whose root controller is a schedule view controller.
        scheduleNavigationController = ScheduleNavigationController(rootViewController: scheduleViewController)
        scheduleNavigationController.tabBarItem.title = "Schedule"
        self.addChild(scheduleNavigationController)
        
        // Creates a navigation controller for todos, whose root controller is a todo view controller.
        toDoNavigationController = ToDoNavigationController(rootViewController: toDoViewController)
        toDoNavigationController.tabBarItem.title = "To Do"
        self.addChild(toDoNavigationController)

        // Badges.
        if let emergentTaskNumber = ToDo.loadToDo()?.getNumberOf(statisticalTask: "Emergent"),
            let overdueTaskNumber = ToDo.loadToDo()?.getNumberOf(statisticalTask: "Overdue") {
            let badgeNumber = emergentTaskNumber + overdueTaskNumber

            // Badge on the tab bar item.
            if badgeNumber > 0 {
                toDoNavigationController.tabBarItem.badgeValue = String(badgeNumber)
            }
            
            // Badge on the app icon.
            let identifier = "identifier"
            let content = UNMutableNotificationContent()
            content.badge = NSNumber(value: badgeNumber)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10 * 60, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) {
                error in
            }
        }
    }
}
