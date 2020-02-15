//
//  TabBarViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var gradientLayer: CAGradientLayer!
    
    var assignmentsNavigationViewController: AssignmentsNavigationViewController!
    var assignmentsViewController: AssignmentsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Adds a gradient layer.
        gradientLayer = CAGradientLayer()
        self.view.addGradientLayer(gradientLayer: gradientLayer, colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        
        // Creates a navigation controller for assignments, whose root controller is a assignments view controller.
        assignmentsViewController = AssignmentsViewController()
        assignmentsNavigationViewController = AssignmentsNavigationViewController(rootViewController: assignmentsViewController)
        self.addChild(assignmentsNavigationViewController)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
