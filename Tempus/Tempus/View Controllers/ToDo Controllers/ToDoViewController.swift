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

        toDoList =
            ToDo.loadToDo() ??
            [
                ToDo(category: "Courses", tasks: [Task(content: "courses", category: "Courses")]),
                ToDo(category: "School", tasks: [Task(content: "school", category: "School")]),
                ToDo(category: "Others", tasks: [Task(content: "others", category: "Others")]),
        ]
        
        updateViews()
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
        
        toDoTableView?.estimatedRowHeight = 120
        toDoTableView?.rowHeight = UITableView.automaticDimension
    }
    
    @objc func presentAddingView() {
        let toDoEditViewController = ToDoEditViewController()
        toDoEditViewController.updateValues(task: Task(content: nil, dateInterval: Interval(start: Date().dateOfCurrentTimeZone(), duration: 3600)), toDoViewController: self, mode: "a", oldIdx: nil)
        navigationController?.present(ToDoEditNavigationViewController(rootViewController: toDoEditViewController), animated: true, completion: nil)
    }
    
//    func clsIndex2Bool(clsIndex: Int) -> (Bool, Bool, Bool)? {
//        switch clsIndex {
//        case 0: return (true, false, false)
//        case 1: return (false, true, true)
//        case 2: return (false, true, false)
//        case 3: return (false, false, true)
//        case 4: return (false, false, false)
//        default: return nil
//        }
//    }
    
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
//        let (isRepeated, isEmergent, isImportant) = clsIndex2Bool(clsIndex: originalIndices!.clsIndex)!
        
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
//        if originalIndices == nil {
//            toDo?[currentIndex!].tasks.append(task)
//        } else if originalIndices != nil && currentIndex == nil {
//            toDo?[originalIndices!.clsIndex].tasks.remove(at: originalIndices!.taskIndex)
//        } else {
//            if originalIndices!.clsIndex == currentIndex {
//                toDo?[originalIndices!.clsIndex].tasks[originalIndices!.taskIndex] = task
//            } else {
//                toDo?[originalIndices!.clsIndex].tasks.remove(at: originalIndices!.taskIndex)
//                toDo?[currentIndex!].tasks.append(task)
//            }
//        }
        if mode == "a" {
            toDoList[getCategoryIdx(category: task.category)].tasks.append(task)
        }
        
        if mode == "e" {
            toDoList[oldIdx!.categoryIdx].tasks.remove(at: oldIdx!.taskIdx)
            toDoList[getCategoryIdx(category: task.category)].tasks.append(task)
        }
        
        if mode == "d" {
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
