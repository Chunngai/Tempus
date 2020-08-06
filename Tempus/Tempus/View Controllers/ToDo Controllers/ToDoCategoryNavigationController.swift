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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customizes the navigation bar.
        navigationBar.setTransparent()
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addGradientLayer(frame: self.view.bounds)
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
