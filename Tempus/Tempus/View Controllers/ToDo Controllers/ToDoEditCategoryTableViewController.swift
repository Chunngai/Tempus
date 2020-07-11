//
//  ToDoCategoryTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditCategoryTableViewController: UITableViewController {
    // MARK: - Models
    var categories: [String]!
    
    // MARK: - Controllers
    
    var toDoEditViewController: ToDoEditViewController!
        
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Customized funcs
    
    func updateViews() {
        view.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        
        // Title of navigation item.
        navigationItem.title = "Categories"
        
        tableView.register(ToDoCategoryTableViewCell.classForCoder(), forCellReuseIdentifier: "toDoCategoryTableViewCell")
    }
    
    func updateValues(toDoEditViewController: ToDoEditViewController) {
        self.toDoEditViewController = toDoEditViewController
        self.categories = toDoEditViewController.toDoViewController.toDoList.categories
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoCategoryTableViewCell()
        
        cell.updateValues(text: categories[indexPath.row])
        cell.textfield.isEnabled = false
        
        return cell
    }
    
    // MARK: - Table view delegate

    // When a category is tapped.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoEditViewController.currentIdx = indexPath.row
        toDoEditViewController.dismiss(animated: true, completion: nil)
    }
}
