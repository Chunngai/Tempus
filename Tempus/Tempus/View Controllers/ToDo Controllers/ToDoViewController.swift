//
//  ToDoViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/28.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Data source.
    var toDoList: [ToDo]! {
        didSet {
            for i in 0..<self.toDoList.count {
                self.toDoList[i].tasks.sort()
            }
            
            ToDo.saveToDo(self.toDoList!)
            
            checkEmergentTasks()
        }
    }
    
    var categories: [String] {
        get {
            var categoryList: [String] = []
            for todo in toDoList {
                categoryList.append(todo.category)
            }
            
            return categoryList
        }
        set {
            var newToDoList: [ToDo] = []
            for category in newValue {
                var toDo = ToDo(category: category, tasks: [])
                if self.categories.contains(category) {
                    toDo.tasks = toDoList[getCategoryIdx(category: category)].tasks
                }
                
                newToDoList.append(toDo)
            }
            
            toDoList = newToDoList
            
            toDoTableView?.reloadData()
        }
    }
    
    
    // Views.
    var toDoTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toDoList = ToDo.loadToDo()
        
        updateViews()
        
        Thread.detachNewThreadSelector(#selector(reloadTableView), toTarget: self, with: nil)
    }
    
    @objc func reloadTableView() {
        while true {
            DispatchQueue.main.async {
                self.toDoTableView?.reloadData()
            }
            
            Thread.sleep(forTimeInterval: 3600)
        }
    }
    
    func updateViews() {
        // Sets the title of the navigation item.
        navigationItem.title = "To Do"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
                
        // Adds a table view.
        toDoTableView = UITableView(frame:
            CGRect(x: 0,
                   y: navigationController!.navigationBar.frame.height,
                   width: view.frame.width,
                   height: view.frame.height - navigationController!.navigationBar.frame.height - tabBarController!.tabBar.frame.height), style: .grouped)
        view.addSubview(toDoTableView!)
        
        toDoTableView?.dataSource = self
        toDoTableView?.delegate = self
        
        toDoTableView?.register(ToDoTableViewCell.classForCoder(), forCellReuseIdentifier: "toDoTableViewCell")
        toDoTableView?.register(ToDoHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "toDoHeaderView")
        
        toDoTableView?.backgroundColor = UIColor.sky.withAlphaComponent(0)
        toDoTableView?.separatorStyle = .none
        
        toDoTableView?.estimatedRowHeight = 130
        toDoTableView?.rowHeight = UITableView.automaticDimension
    }
    
    func checkEmergentTasks() {
        var count = 0
        
        for toDo in toDoList {
            for task in toDo.tasks {
                if task.isOverdue {
                    count += 1
                } else {
                    if let start = task.dateInterval.start, Date().dateOfCurrentTimeZone() < start,  // Before start.
                        DateInterval(start: Date().dateOfCurrentTimeZone(), end: start).getComponents([.day]).day! < 3 {  // Less than 3 days.
                            count += 1
                    } else if let due = task.dateInterval.end, Date().dateOfCurrentTimeZone() < due,  // Before end.
                        DateInterval(start: Date().dateOfCurrentTimeZone(), end: due).getComponents([.day]).day! < 3 {  // Less than 3 days.
                            count += 1
                    }
                }
            }
        }
        
        let toDoItem = tabBarController?.tabBar.items![1]
        if count > 1 {
            toDoItem?.badgeValue = String(count)
        } else {
            toDoItem?.badgeValue = nil
        }
    }
    
    @objc func presentAddingView() {
        let toDoEditViewController = ToDoEditViewController()
        toDoEditViewController.updateValues(task: Task(content: nil, dateInterval: Interval(start: Date().dateOfCurrentTimeZone(), duration: 3600)), toDoViewController: self, mode: "a", oldIdx: nil)
        navigationController?.present(ToDoEditNavigationViewController(rootViewController: toDoEditViewController), animated: true, completion: nil)
    }
    
    func presentEditingView(task: Task) {
        let toDoEditViewController = ToDoEditViewController()
        
        var oldIdx: (Int, Int)?
        for clsIndex in 0..<toDoList.count {
            for taskIndex in 0..<toDoList[clsIndex].tasks.count {
                if toDoList[clsIndex].tasks[taskIndex] == task {
                    oldIdx = (clsIndex, taskIndex)
                }
            }
        }
        
        toDoEditViewController.updateValues(task: task, toDoViewController: self, mode: "e", oldIdx: oldIdx)
        navigationController?.present(ToDoEditNavigationViewController(rootViewController: toDoEditViewController), animated: true, completion: nil)
    }
    
    func getCategoryIdx(category: String) -> Int {
        for i in 0..<toDoList.count {
            if toDoList[i].category == category {
                return i
            }
        }
        
        return 0
    }
    
    func editTask(task: Task, mode: String, oldIdx: (categoryIdx: Int, taskIdx: Int)?) {
        if mode == "a" {
            toDoList[getCategoryIdx(category: task.category)].tasks.append(task)
        } else if mode == "e" {
            toDoList[oldIdx!.categoryIdx].tasks.remove(at: oldIdx!.taskIdx)
            toDoList[getCategoryIdx(category: task.category)].tasks.append(task)
        } else if mode == "d" {
            toDoList[oldIdx!.categoryIdx].tasks.remove(at: oldIdx!.taskIdx)
        }
        
        toDoTableView?.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoTableViewCell()
        
        cell.updateValues(task: toDoList[indexPath.section].tasks[indexPath.row], toDoViewController: self)

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ToDoHeaderView()
        
        headerView.updateValues(sectionName: toDoList[section].category)
    
        return headerView
    }
    
    // For hiding empty categories.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if toDoList[section].tasks.isEmpty {
            return 0
        }
        return tableView.sectionHeaderHeight
    }
    
    // For hiding empty categories.
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    // For hiding empty categories.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if toDoList[section].tasks.isEmpty {
            return 0
        }
        return tableView.sectionFooterHeight
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
