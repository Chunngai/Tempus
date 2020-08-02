//
//  ToDoNavigationViewController.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoCategoryNavigationController: UINavigationController {

    // MARK: - Controllers.
    
    var delegate_: ToDoViewController?
    
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
        if let delegate_ = delegate_ {
            let allCategories = delegate_.toDoList.categories + delegate_.toDoList.statisticalCategories
            if !allCategories.contains(delegate_.displayingCategory) {
                delegate_.resetDisplayingCategory()
            }
        }
    }
    
    func updateValues(delegate: ToDoViewController) {
        self.delegate_ = delegate
    }
}

protocol ToDoCategoryNavigationControllerDelegate {
    func resetDisplayingCategory()
}
