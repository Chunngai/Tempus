//
//  ToDoRepetitionNavigationViewController.swift
//  Tempus
//
//  Created by Sola on 2020/7/31.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditRepetitionNavigationController: UINavigationController {

    // MARK: - Views.
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizes the navigation bar.
        navigationBar.setTransparent()
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addGradientLayer(frame: self.view.bounds)
    }
}
