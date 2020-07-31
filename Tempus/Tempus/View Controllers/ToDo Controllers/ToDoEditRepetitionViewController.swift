//
//  ToDoRepetitionViewController.swift
//  Tempus
//
//  Created by Sola on 2020/7/31.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditRepetitionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Views
    
    var toDoEditRepetitionTableView: UITableView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Customized funcs
    
    func updateViews() {
        view.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        
        // Title of navigation item.
        navigationItem.title = "Repetition"
    
        // Table view.
        toDoEditRepetitionTableView = UITableView(frame: CGRect(x: 0,
                                                                y: navigationController!.navigationBar.frame.height,
                                                                width: view.frame.width,
                                                                height: view.frame.height - navigationController!.navigationBar.frame.height),
                                                  style: .plain)
        view.addSubview(toDoEditRepetitionTableView)
        
        toDoEditRepetitionTableView.dataSource = self
        toDoEditRepetitionTableView.delegate = self
                
        toDoEditRepetitionTableView.backgroundColor = UIColor.sky.withAlphaComponent(0)
    }
    
//    func updateValues(toDoEditViewController: ToDoEditViewController) {
//        self.toDoEditViewController = toDoEditViewController
//        self.categories = toDoEditViewController.toDoViewController.toDoList.categories
//    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 || indexPath.row == 1 {
            cell = UITableViewCell(style: .default, reuseIdentifier: "toDoRepetitionTableViewCell")
            cell.textLabel?.textColor = .white
            cell.backgroundColor = UIColor.sky.withAlphaComponent(0)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = "Never"
            } else {
                cell.textLabel?.text = "Every Day"
            }
        } else {
            cell = UITableViewCell()
//            cell.contentView.addSubview(UIDatePicker())
        }
        
        return cell
    }
    
    // MARK: - Table view delegate

    // When a category is tapped.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
