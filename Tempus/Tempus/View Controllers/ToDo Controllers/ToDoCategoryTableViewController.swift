//
//  ToDoCategoryTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoCategoryTableViewController: UITableViewController {
    // Models.
    var categories: [String] {
        get {
            return toDoEditViewController.toDoViewController.categories
        }
        set {
            toDoEditViewController.toDoViewController.categories = newValue
        }
    }
    
    // Controllers.
    var toDoEditViewController: ToDoEditViewController!
    
    var tmpCategories: [String]!
    
    // Init.
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // Customized funcs.
    func updateViews() {
        view.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        
        // Title of navigation item.
        navigationItem.title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
        tableView.register(ToDoCategoryTableViewCell.classForCoder(), forCellReuseIdentifier: "toDoCategoryTableViewCell")
    }
    
    func updateValues(toDoEditViewController: ToDoEditViewController) {
        self.toDoEditViewController = toDoEditViewController
        
        tmpCategories = categories
    }
    
    @objc func editButtonTapped() {
        isEditing = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        tableView.reloadData()
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
        for i in 0..<tmpCategories.count {
            if let cell = (tableView.cellForRow(at: IndexPath(row: i, section: 0))) as? ToDoCategoryTableViewCell {
                let category = cell.textfield.text!
                
                // Sees if the category name is not empty.
                if category.trimmingCharacters(in: CharacterSet(charactersIn: " ")) == "" {
                    emptyCategoriesAlert()
                    return
                }
                
                tmpCategories[i] = category
            }
        }
        
        // Repeated category name not allowed.
        if tmpCategories.count != Set(tmpCategories).count {
            repeatedCategoriesAlert()
            return
        }
        
        // Empty category name not allowed.
        if tmpCategories.isEmpty {
            tmpCategories = ["Default"]
        }
        
        if !tmpCategories.contains(toDoEditViewController.task.category) {
            toDoEditViewController.task.category = tmpCategories[0]
        }
        
        isEditing = false
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        categories = tmpCategories
        
        tableView.reloadData()
    }
    
    @objc func cancelButtonTapped() {
        isEditing = false
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
        tmpCategories = categories
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpCategories.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoCategoryTableViewCell()
        
        // Normal categories.
        if indexPath.row < tmpCategories.count {
            cell.updateValues(text: tmpCategories[indexPath.row])
            cell.textfield.isEnabled = isEditing ? true : false
        }
        
        // Add button.
        if indexPath.row == tmpCategories.count {
            cell.textfield.isEnabled = false
            if isEditing {
                cell.updateValues(text: "Add a new category")
            }
        }
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = (tableView.cellForRow(at: indexPath) as! ToDoCategoryTableViewCell).textfield.text!
            if categories.contains(category) {
                let idx = toDoEditViewController.toDoViewController.toDoList.getCategoryIdx(category: category)
                if !toDoEditViewController.toDoViewController.toDoList[idx].tasks.isEmpty {  // There are tasks of the category.
                    notEmptyCategoryDeletionAlert()
                    return
                }
            }
            tmpCategories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            tmpCategories.append("")
            tableView.insertRows(at: [indexPath], with: .automatic)
        }    
    }
    
    // Editing style.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == tmpCategories.count {
            return UITableViewCell.EditingStyle.insert
        } else if indexPath.row < tmpCategories.count {
            return UITableViewCell.EditingStyle.delete
        }
        return UITableViewCell.EditingStyle.none
    }

    // When a category is tapped.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < tmpCategories.count {
            toDoEditViewController.currentIdx = indexPath.row
            
            toDoEditViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < tmpCategories.count {
            return true
        } else {
            return false
        }
    }
}
