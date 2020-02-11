//
//  AppDelegate.swift
//  Tempus
//
//  Created by Sola on 2020/2/9.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Creates a window.
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        // Creates a tab bar controller as the root controller.
        let tabBarController = UITabBarController()
        setTabBarControllerBackgroundColor(tabBarController: tabBarController)
        window?.rootViewController = tabBarController
        
        // Creates a view controller for assignments.
        let assignmentsViewController = AssignmentsViewController()
        
        // Creates a navigation controller for the assignment view controller.
        let assignmentNavigationController = UINavigationController(rootViewController: assignmentsViewController)
        tabBarController.addChild(assignmentNavigationController)
        
        return true
    }
    
    func setTabBarControllerBackgroundColor(tabBarController: UITabBarController) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.aqua.cgColor, UIColor.sky.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
//        if let navigationBarBounds = navigationController?.navigationBar.bounds {
//            gradientLayer.frame = navigationBarBounds
//
//            navigationController?.navigationBar.layer.addSublayer(gradientLayer)
//        }
        gradientLayer.frame = tabBarController.view.bounds
        tabBarController.view.layer.sublayers?.insert(gradientLayer, at: 0)
    }

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

