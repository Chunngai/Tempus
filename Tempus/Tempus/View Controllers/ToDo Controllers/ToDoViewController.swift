//
//  ToDoViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/28.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Models
    
    var toDoList: [ToDo]! {
        didSet {
            // Sorts tasks of each category.
            for i in 0..<self.toDoList.count {
                self.toDoList[i].tasks.sort()
            }
            
            ToDo.saveToDo(self.toDoList!)
            
            // Badge.
            let toDoItem = tabBarController?.tabBar.items![1]
            if self.toDoList.emergentTaskNumber > 0 {
                toDoItem?.badgeValue = String(self.toDoList.emergentTaskNumber)
                UIApplication.shared.applicationIconBadgeNumber = self.toDoList.emergentTaskNumber
            } else {
                toDoItem?.badgeValue = nil
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            
            self.toDoTableView?.reloadData()
        }
    }
    
    // MARK: - Controllers.
    var displayingCategory: String = "Unfinished" {
        didSet {
            navigationItem.title = displayingCategory
            toDoTableView?.reloadData()
        }
    }
    
    // MARK: - Views
    
    var toDoTableView: UITableView?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toDoList = ToDo.loadToDo()
        
        updateViews()
        
        Thread.detachNewThreadSelector(#selector(reloadTableView), toTarget: self, with: nil)
    }
    
    // MARK: - Customized funcs
    
    func updateViews() {
        // Sets the title of the navigation item.
        navigationItem.title = "To Do"
        
        // Nav item buttons.
        let categoryButton = UIBarButtonItem(title: "☆", style: .plain, target: self, action: #selector(categoryButtonTapped))
        categoryButton.tintColor = .white
        navigationItem.leftBarButtonItem = categoryButton
        
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
    
    @objc func reloadTableView() {
         while true {
             DispatchQueue.main.async {
                 self.toDoTableView?.reloadData()
             }
             
             Thread.sleep(forTimeInterval: 3600)
         }
     }
    
    @objc func categoryButtonTapped() {
        let toDoCategoryTableViewController = ToDoCategoryViewController()
        toDoCategoryTableViewController.updateValues(toDoViewController: self)

        let toDoCategoryNavigationViewController = ToDoCategoryNavigationViewController(rootViewController: toDoCategoryTableViewController)
        toDoCategoryNavigationViewController.updateValues(toDoViewController: self)
        navigationController?.present(toDoCategoryNavigationViewController, animated: true, completion: nil)
    }
    
    @objc func presentAddingView() {
        let toDoEditViewController = ToDoEditViewController()
        toDoEditViewController.updateValues(task: Task(content: nil, dateInterval: Interval(start: Date().currentTimeZone(), duration: 3600)),
                                            toDoViewController: self,
                                            mode: "a",
                                            oldIdx: nil)
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
    
    func toggleFinishStatus(task: Task) {
        for i in 0..<toDoList.count {
            if let idx = toDoList[i].tasks.firstIndex(of: task) {
                toDoList[i].tasks[idx].isFinished.toggle()
                
                break
            }
        }
    }
    
    func editTask(task: Task, mode: String, oldIdx: (categoryIdx: Int, taskIdx: Int)?) {
        if mode == "a" {  // Append.
            let categoryIdx = toDoList.getCategoryIdx(category: task.category)
            toDoList[categoryIdx].tasks.append(task)
        } else if mode == "e" {  // Update.
            toDoList[oldIdx!.categoryIdx].tasks.remove(at: oldIdx!.taskIdx)  // Removes the old one.
            
            let categoryIdx = toDoList.getCategoryIdx(category: task.category)
            toDoList[categoryIdx].tasks.append(task)
        } else if mode == "d" {  // Delete.
            toDoList[oldIdx!.categoryIdx].tasks.remove(at: oldIdx!.taskIdx)
        }
        
        toDoTableView?.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if toDoList.categories.contains(displayingCategory) {
            return 1
        } else if toDoList.statisticalCategories.contains(displayingCategory) {
            return toDoList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if toDoList.categories.contains(displayingCategory) {
            return toDoList[toDoList.getCategoryIdx(category: displayingCategory)].unfinishedTasks.count
        } else if toDoList.statisticalCategories.contains(displayingCategory) {
            return toDoList.getStatisticalTasks(displayingCategory, of: section).count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoTableViewCell()
        
        var task: Task
        if toDoList.categories.contains(displayingCategory) {
            task = toDoList[toDoList.getCategoryIdx(category: displayingCategory)].unfinishedTasks[indexPath.row]
        } else if toDoList.statisticalCategories.contains(displayingCategory) {
            task = toDoList.getStatisticalTasks(displayingCategory, of: indexPath.section)[indexPath.row]
        } else {
            task = Task()
        }
        cell.updateValues(task: task, toDoViewController: self)

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ToDoHeaderView()
        
        var sectionName: String
        if toDoList.categories.contains(displayingCategory) {
            sectionName = displayingCategory
        } else if toDoList.statisticalCategories.contains(displayingCategory) {
            sectionName = toDoList[section].category
        } else {
            sectionName = ""
        }
        headerView.updateValues(sectionName: sectionName)
    
        return headerView
    }
    
    // For hiding empty categories.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if toDoList.categories.contains(displayingCategory),
            toDoList[section].tasks.isEmpty {
            return 0
        } else if toDoList.statisticalCategories.contains(displayingCategory),
            toDoList.getStatisticalTasks(displayingCategory, of: section).count == 0 {
            return 0
        } else {
            return tableView.sectionHeaderHeight
        }
    }
    
    // For hiding empty categories.
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    // For hiding empty categories.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if toDoList.categories.contains(displayingCategory),
            toDoList[section].tasks.isEmpty {
            return 0
        } else if toDoList.statisticalCategories.contains(displayingCategory),
            toDoList.getStatisticalTasks(displayingCategory, of: section).count == 0 {
            return 0
        } else {
            return tableView.sectionFooterHeight
        }
    }
}

extension Task {
    var isBeforeSoon: Bool {  // start - current >= 3
        if let start = dateInterval.start, Date().currentTimeZone() < start,
            DateInterval(start: Date().currentTimeZone(), end: start).getComponents([.day]).day! >= 3 {
            return true
        }
        
        return false
    }
    
    var isSoon: Bool {  // start - current < 3 and due - current > 3
        if let start = dateInterval.start, Date().currentTimeZone() < start,
            DateInterval(start: Date().currentTimeZone(), end: start).getComponents([.day]).day! < 3 {
            return true
        }
        
        return false
    }
    
    var isDoing: Bool {
        if let start = dateInterval.start,
            let due = dateInterval.end,
            start <= Date().currentTimeZone(),
            Date().currentTimeZone() <= due {
            return true
        }
        
        return false
    }
    
    var isEmergent: Bool {
        if let due = dateInterval.end,
            !isOverdue && DateInterval(start: Date().currentTimeZone(), end: due).getComponents([.day]).day! < 3 {
            return true
        }
        
        return false
    }
}

extension ToDo {
    var soonTasks: [Task] {
        var soonTasks: [Task] = []
        for task in self.tasks {
            if task.isSoon {
                soonTasks.append(task)
            }
        }
        
        return soonTasks
    }
    
    var doingTasks: [Task] {
        var doingTasks: [Task] = []
        for task in self.tasks {
            if task.isDoing {
                doingTasks.append(task)
            }
        }
        
        return doingTasks
    }
    
    var emergentTasks: [Task] {
        var emergentTasks: [Task] = []
        for task in self.tasks {
            if task.isEmergent {
                emergentTasks.append(task)
            }
        }
        
        return emergentTasks
    }
    
    var overdueTasks: [Task] {
        var overdueTasks: [Task] = []
        for task in self.tasks {
            if task.isOverdue {
                overdueTasks.append(task)
            }
        }
        
        return overdueTasks
    }
    
    var unfinishedTasks: [Task] {
        var unfinishedTasks: [Task] = []
        for task in self.tasks {
            if !task.isFinished {
                unfinishedTasks.append(task)
            }
        }
        
        return unfinishedTasks
    }
    
    var finishedTasks: [Task] {
        var finishedTasks: [Task] = []
        for task in self.tasks {
            if task.isFinished {
                finishedTasks.append(task)
            }
        }
        
        return finishedTasks
    }
}

extension Array where Element == ToDo {
    var emergentTaskNumber: Int {
        var count = 0
        for toDo in self {
            count += toDo.emergentTasks.count
        }
        
        return count
    }
    
    var categories: [String] {
        get {
            // Gets all categories from the todo list.
            var categoryList: [String] = []
            for todo in self {
                categoryList.append(todo.category)
            }
            
            return categoryList
        }
        set {
            var newToDoList: [ToDo] = []
            for category in newValue {
                var toDo = ToDo(category: category, tasks: [])
                if self.categories.contains(category) {  // The category originally exists.
                    let categoryIdx = self.getCategoryIdx(category: category)
                    toDo.tasks = self[categoryIdx].tasks
                }
                newToDoList.append(toDo)
            }
            
            self = newToDoList
        }
    }
    
    func getCategoryIdx(category: String) -> Int {
        for i in 0..<self.count {
            if self[i].category == category {
                return i
            }
        }
        
        return 0
    }
    
    var statisticalCategories: [String] {
        return ["Soon", "Doing", "Emergent", "Overdue", "Unfinished", "Finished"]
    }
    
    func getStatisticalCategoryIdx(of statisticalCategory: String) -> Int {
        for i in 0..<self.statisticalCategories.count {
            if self.statisticalCategories[i] == statisticalCategory {
                return i
            }
        }
        
        return 0
    }
    
    func getStatisticalTasks(_ statisticalCategory: String, of categoryIndex: Int) -> [Task] {
        let toDo = self[categoryIndex]
        let statisticalCategoryIndex = getStatisticalCategoryIdx(of: statisticalCategory)
        
        switch statisticalCategoryIndex {
        case 0: return toDo.soonTasks
        case 1: return toDo.doingTasks
        case 2: return toDo.emergentTasks
        case 3: return toDo.overdueTasks
        case 4: return toDo.unfinishedTasks
        case 5: return toDo.finishedTasks
        default: return []
        }
    }
}
