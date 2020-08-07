//
//  ToDoCategoryTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Models
    
    var categories: [String] {
        get {
            return toDoList.categories
        }
        set {
            delegate.updateCategories(categories: newValue)
        }
    }
    
    var toDoList: [ToDo]! {
        return delegate.toDoList
    }
    
    // MARK: - Controllers
    
    var delegate: ToDoViewController!
    
    var originalCategories: [String]!
    
    // MARK: - Views
    
    var toDoCategoryTableView: UITableView!
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
                
        // Table view.
        toDoCategoryTableView = UITableView(frame: CGRect(x: 0,
                                                          y: navigationController!.navigationBar.frame.height,
                                                          width: view.frame.width,
                                                          height: view.frame.height - navigationController!.navigationBar.frame.height),
                                            style: .plain)
        view.addSubview(toDoCategoryTableView)
        
        toDoCategoryTableView.dataSource = self
        toDoCategoryTableView.delegate = self
        
        toDoCategoryTableView.register(ToDoCategoryTableViewCell.classForCoder(), forCellReuseIdentifier: "toDoCategoryTableViewCell")
        
        toDoCategoryTableView.backgroundColor = UIColor.sky.withAlphaComponent(0)
    }
    
    func updateValues(delegate: ToDoViewController) {
        self.delegate = delegate
        
        originalCategories = categories
    }
    
    @objc func editButtonTapped() {
        // Enables editing.
        toDoCategoryTableView.isEditing = true
        
        // Changes bar button items.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        // Reloads the table.
        toDoCategoryTableView.reloadData()
    }
    
    func emptyCategoriesAlert() {
        let alertController = UIAlertController(title: "Error", message: "Categories cannot be empty.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func repeatedCategoriesAlert() {
        let alertController = UIAlertController(title: "Error", message: "Categorys cannot be repeated.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func notEmptyCategoryDeletionAlert() {
        let alertController = UIAlertController(title: "Error", message: "The category is not empty. Cannot be deleted.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        for i in 0..<categories.count {
            if let cell = (toDoCategoryTableView.cellForRow(at: IndexPath(row: i, section: 0))) as? ToDoCategoryTableViewCell {
                let category = cell.textField.text!
                
                // Sees if the category name is not empty.
                if category.trimmingCharacters(in: CharacterSet(charactersIn: " ")) == "" || category.isEmpty {
                    emptyCategoriesAlert()
                    return
                }
                
                categories[i] = category
            }
        }
        
        // Repeated category name not allowed.
        if categories.count != Set(categories).count {
            repeatedCategoriesAlert()
            return
        }
        
        // Empty category name not allowed.
        if categories.isEmpty {
            categories = ["Default"]
        }
        
        // Disables editing.
        toDoCategoryTableView.isEditing = false
        
        // Changes bar button items.
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    
        originalCategories = categories
        
        // Reloads the table.
        toDoCategoryTableView.reloadData()
    }
    
    @objc func cancelButtonTapped() {
        // Disables editing.
        toDoCategoryTableView.isEditing = false
        
        // Changes bar button items.
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
        // Rolls back.
        categories = originalCategories
        
        // Reloads the table.
        toDoCategoryTableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {  // Normal categories.
            return categories.count
        } else if section == 1 {  // Add button.
            return 1
        } else {
            return 6
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoCategoryTableViewCell()
        
        if indexPath.section == 0 {  // Normal categories.
            cell.updateValues(text: categories[indexPath.row], taskNumber: toDoList[indexPath.row].unfinishedTasks.count)
            cell.textField.isEnabled = toDoCategoryTableView.isEditing ? true : false
        } else if indexPath.section == 1 {  // Add button.
            cell.textField.isEnabled = false
        } else {
            let statisticalCategory = toDoList.statisticalCategories[indexPath.row]
            cell.updateValues(text: statisticalCategory, taskNumber: toDoList.getNumberOf(statisticalTask: statisticalCategory))
            cell.textField.isEnabled = false
        }
        
        return cell
    }
    
    // MARK: - Table view delegate

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 2 ? true : false
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = (tableView.cellForRow(at: indexPath) as! ToDoCategoryTableViewCell).textField.text!
            if categories.contains(category) {
                let idx = toDoList.getCategoryIdx(category: category)
                if !toDoList[idx].tasks.isEmpty {  // There are tasks of the category.
                    notEmptyCategoryDeletionAlert()
                    return
                }
            }
            
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            originalCategories = categories
        } else if editingStyle == .insert {
            categories.append("")
            tableView.insertRows(at: [IndexPath(row: categories.count - 1, section: 0)], with: .automatic)
        }    
    }
    
    // Editing style.
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {  // Normal categories.
            return .delete
        } else if indexPath.section == 1 {  // Add button.
            return .insert
        } else {
            return .none
        }
    }

    // When a category is tapped.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            delegate.updateDisplayingCategory(category: categories[indexPath.row])
        } else if indexPath.section == 2 {
            let statisticalCategory = toDoList.statisticalCategories[indexPath.row]
            delegate.updateDisplayingCategory(category: statisticalCategory)
        }
        
        delegate.dismiss(animated: true, completion: nil)
    }

    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? true : false
    }
    
    // Supports rearranging.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate.rearrange(oldIndex: sourceIndexPath.row, newIndex: destinationIndexPath.row)
    }
}

extension Array where Element == ToDo {
    func getNumberOf(statisticalTask: String) -> Int {
        var count = 0
        for i in 0..<categories.count {
            count += getStatisticalTasks(statisticalTask, of: i).count
        }
        
        return count
    }
}

protocol ToDoCategoryViewControllerDelegate {
    func updateCategories(categories: [String])
    
    func updateDisplayingCategory(category: String)
    
    func rearrange(oldIndex: Int, newIndex: Int)
}
