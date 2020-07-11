//
//  ToDoNavigationViewController.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditCategoryNavigationViewController: UINavigationController {

    // Views.
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizes the navigation bar.
        navigationBar.setTransparent()
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addGradientLayer(gradientLayer: gradientLayer,
            colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
            locations: [0.0, 1.0],
            startPoint: CGPoint(x: 0, y: 1),
            endPoint: CGPoint(x: 1, y: 0.5),
            frame: self.view.bounds)
    }
}
