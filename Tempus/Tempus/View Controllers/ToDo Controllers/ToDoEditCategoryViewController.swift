//
//  ToDoCategoryTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Models
    
    var categories: [String]!
    
    // MARK: - Controllers
    
    var delegate: ToDoEditViewController!
    
    // MARK: - Views
    
    var toDoEditCategoryTableView: UITableView!
        
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
        
        // Table view.
        toDoEditCategoryTableView = UITableView(frame: CGRect(x: 0,
                                                              y: navigationController!.navigationBar.frame.height,
                                                              width: view.frame.width,
                                                              height: view.frame.height - navigationController!.navigationBar.frame.height),
                                                style: .plain)
        view.addSubview(toDoEditCategoryTableView)
        
        toDoEditCategoryTableView.dataSource = self
        toDoEditCategoryTableView.delegate = self
        
        toDoEditCategoryTableView.register(ToDoCategoryTableViewCell.classForCoder(), forCellReuseIdentifier: "toDoCategoryTableViewCell")
        
        toDoEditCategoryTableView.backgroundColor = UIColor.sky.withAlphaComponent(0)
    }
    
    func updateValues(delegate: ToDoEditViewController) {
        self.delegate = delegate
        self.categories = delegate.delegate.toDoList.categories
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoCategoryTableViewCell()
        
        cell.updateValues(text: categories[indexPath.row])
        cell.textField.isEnabled = false
        
        return cell
    }
    
    // MARK: - Table view delegate

    // When a category is tapped.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectCategory(at: indexPath.row)
    }
}

protocol ToDoEditCategoryViewControllerDelegate {
    func selectCategory(at index: Int)
}
