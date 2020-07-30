//
//  ToDoNavigationViewController.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoCategoryNavigationViewController: UINavigationController {

    // MARK: - Controllers.
    
    var
    toDoViewController: ToDoViewController?
    // MARK: - Views.
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        if let toDoCategoryViewController = viewControllers[0] as? ToDoCategoryViewController {
            // Discards the changes.
            if toDoCategoryViewController.toDoCategoryTableView.isEditing {
                toDoCategoryViewController.categories = toDoCategoryViewController.originalCategories
            }
        }
        
        // Checks if the displaying category is in categories + statisticalCategories.
        // (May not in due to deletion.)
        if let toDoViewController = toDoViewController {
            let allCategories = toDoViewController.toDoList.categories + toDoViewController.toDoList.statisticalCategories
            if !allCategories.contains(toDoViewController.displayingCategory) {
                toDoViewController.displayingCategory = toDoViewController.toDoList.categories[0]
            }
        }
    }
    
    func updateValues(toDoViewController: ToDoViewController) {
        self.toDoViewController = toDoViewController
    }
}
