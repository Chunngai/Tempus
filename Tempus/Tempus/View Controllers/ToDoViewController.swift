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
    var toDo: [ToDo]! {
        didSet {
            ToDo.saveToDo(self.toDo!)
        }
    }
    
    // Views.
    var toDoTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toDo =
            ToDo.loadToDo() ??
            [
                ToDo(cls: "Emergent & Important", tasks: [Task(content: "aaaaaaaaaaaaaaaa", dateInterval: nil, isFinished: false)]),
                ToDo(cls: "Emergent & Not Important", tasks: [Task(content: "bbb", dateInterval: nil, isFinished: false)]),
                ToDo(cls: "Not Emergent & Important", tasks: [Task(content: "ccc", dateInterval: nil, isFinished: false)]),
                ToDo(cls: "Not Emergent & Not Important", tasks: [Task(content: "ddd", dateInterval: nil, isFinished: false)]),
                
        ]
        
        updateViews()
    }
    
    func updateViews() {
        // Sets the title of the navigation item.
        navigationItem.title = "To Do"
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(UIView())
        
        // Adds a table view.
        toDoTableView = UITableView(frame:
            CGRect(x: 0,
                   y: navigationController!.navigationBar.frame.maxY,
//                    + navigationController!.navigationBar.frame.height,
                   width: view.frame.width,
                   height: view.frame.height
                    - (navigationController!.navigationBar.frame.maxY
                        + navigationController!.navigationBar.frame.height)), style: .grouped)
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
        toDoEditViewController.task = Task()
        toDoEditViewController.toDoViewController = self
        navigationController?.present(ToDoEditNavigationViewController(rootViewController: toDoEditViewController), animated: true, completion: nil)
    }
    
    func presentEditingView(task: Task) {
        let toDoEditViewController = ToDoEditViewController()
        toDoEditViewController.task = task
        toDoEditViewController.toDoViewController = self
        navigationController?.present(ToDoEditNavigationViewController(rootViewController: toDoEditViewController), animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDo[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoTableViewCell()
        
        cell.updateValues(task: toDo[indexPath.section].tasks[indexPath.row], toDoViewController: self)

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ToDoHeaderView()
        
        headerView.updateValues(sectionName: toDo[section].cls)
        
        return headerView
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
