//
//  ScheduleViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskEditingDelegate {
    // MARK: - Models
    
    var schedule: Schedule! {
        didSet {
            // Sorts the schedule.
            self.schedule.tasks.sort()
            
            // Saves to disk.
            Schedule.saveSchedule(self.schedule)
            
            // Sets the title of the navigation item.
            DispatchQueue.main.async {
                self.navigationItem.title = "\(self.schedule.date.formattedDate()) \(self.schedule.date.shortWeekdaySymbol)"
            }
            
            // Determines the text of the commit bar button.
            if let committed = self.schedule.committed {
                self.committedBarButton.title = committed ? "✓" : "✗"
            } else {
                self.committedBarButton.title = ""
            }
        }
    }
    
    // MARK: - Controllers
    
    var editable: Bool {
        return (schedule.date >= Date().currentTimeZone()
            || DateInterval(start: schedule.date, end: Date().currentTimeZone()).getComponents([.day]).day! <= 0)
    }
    
    // MARK: - Views
    
    var scheduleTableView: UITableView!
    
    var datePickerView: ScheduleDatePickerView!
    
    var committedBarButton: UIBarButtonItem!
    
    var advancementArcLayer = CAShapeLayer()
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateViews()
        
        schedule = Schedule.loadSchedule(date: Date().currentTimeZone())
        
        Thread.detachNewThreadSelector(#selector(checkEditabilityThread), toTarget: self, with: nil)
        Thread.detachNewThreadSelector(#selector(checkGithubCommitsThread), toTarget: self, with: nil)
    }
    
    // MARK: - Customized funcs
    func updateViews() {
        // Bar buttons.
        let dateBarButton = UIBarButtonItem(title: "Date", style: .plain, target: self, action: #selector(dateBarButtonTapped_))
        dateBarButton.tintColor = .white

        committedBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(checkGithubCommits))
        committedBarButton.tintColor = .white
        
        navigationItem.leftBarButtonItems = [dateBarButton, committedBarButton]
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
        addBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = addBarButton
                
        // Table view.
        scheduleTableView = UITableView(frame:
            CGRect(
                x: 0,
                y: navigationController!.navigationBar.frame.height,
                width: view.frame.width,
                height: view.frame.height - navigationController!.navigationBar.frame.height - tabBarController!.tabBar.frame.height
            ), style: .grouped)
        view.addSubview(scheduleTableView!)

        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        
        scheduleTableView.register(ScheduleTableViewCell.classForCoder(), forCellReuseIdentifier: "ScheduleTableViewCell")
        
        scheduleTableView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        scheduleTableView.separatorStyle = .none
        
        scheduleTableView.estimatedRowHeight = 130
        scheduleTableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func dateBarButtonTapped_() {
        datePickerView = ScheduleDatePickerView(datePickerFrame: CGRect(x: UIScreen.main.bounds.width * 0.03,
                                                                        y: navigationController!.navigationBar.bounds.height,
                                                                        width: UIScreen.main.bounds.width/1.3,
                                                                        height: UIScreen.main.bounds.height/3.5),
                                                scheduleViewController: self,
                                                date: schedule.date)
        UIApplication.shared.windows.last?.addSubview(datePickerView)
    }
    
    @objc func checkGithubCommits() {
        // Makes a request.
        let url = URL(string: "https://github.com/Chunngai")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                let htmlText = string
                
                // Gets the value of data-count.
                let pattern = "data-count=\"(\\d+)\" data-date=\"\(self.schedule.date.formattedLongDate(separator: "-"))\""
                let regex = try? NSRegularExpression(pattern: pattern, options: [])
                let res = regex?.firstMatch(in: htmlText, options: [], range: NSRange(location: 0, length: htmlText.count))
                
                // Sees if committed.
                if let res = res {
                    let dataCountRange = res.range(at: 1)
                    let startIndex = htmlText.index(htmlText.startIndex, offsetBy: dataCountRange.location)
                    let endIndex = htmlText.index(htmlText.startIndex, offsetBy: dataCountRange.location + dataCountRange.length)
                    let dataCount = Int(htmlText[startIndex..<endIndex])!
                    if dataCount > 0 {
                        self.schedule.committed = true
                    }
                }
            }
        }
        task.resume()
    }
    
    @objc func checkGithubCommitsThread() {
        while true {
            DispatchQueue.main.async {
                self.checkGithubCommits()
            }
            
            Thread.sleep(forTimeInterval: 3600)
        }
    }
    
    func verifyEditability() {
        if !editable {
            // Rm the add button.
            navigationItem.rightBarButtonItem = nil
        } else {
            // Adds an add button.
            let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
            addBarButton.tintColor = .white
            navigationItem.rightBarButtonItem = addBarButton
        }
    }
    
    @objc func checkEditabilityThread() {
        while true {
            DispatchQueue.main.async {
                self.verifyEditability()
            }
            
            Thread.sleep(forTimeInterval: 5 * 60)
        }
    }
    
    func changeSchedule() {
        Schedule.saveSchedule(schedule)
        
        // Gets the schedule of the selected date.
        let selectedDate = datePickerView.datePicker.date.currentTimeZone()
        schedule = Schedule.loadSchedule(date: selectedDate)!

        // Reloads the table.
        scheduleTableView.reloadData()
        
        // Sees if it is editable.
        verifyEditability()
    }
    
    @objc func presentAddingView() {
        // Gets initStart, initDuration and initEnd.
        var initStart: Date
        var initDuration: TimeInterval
        var initEnd: Date
        if let latestTask = schedule.latestUnfinishedTask {
            initStart = latestTask.dateInterval.end!
            initDuration = latestTask.dateInterval.duration!
            initEnd = Date(timeInterval: initDuration, since: initStart)
        } else {
            if Date().currentTimeZone() < schedule.date {  // More likely to plan for the next day.
                initStart = Date(hour: 8, minute: 30).currentTimeZone()
            } else {  // More likely to plan for the current day.
                let components = Date().currentTimeZone().getComponents([.hour, .minute])
                initStart = Date(hour: components.hour!, minute: components.minute!).currentTimeZone()
            }
            initDuration = 2400
            initEnd = Date(timeInterval: initDuration, since: initStart)
        }
        
        // Presents a schedule view controller.
        let scheduleEditViewController = ScheduleEditViewController()
        scheduleEditViewController.updateValues(scheduleViewController: self, task: Task(),
                                                initStart: initStart, initDuration: initDuration, initEnd: initEnd,
                                                indexCountedFromOne: nil)
        navigationController?.present(ScheduleEditNavigationViewController(rootViewController: scheduleEditViewController), animated: true, completion: nil)
    }
    
    func presentEditingView(task: Task) {
        // Presents a schedule view controller.
        let scheduleEditViewController = ScheduleEditViewController()
        scheduleEditViewController.updateValues(scheduleViewController: self, task: task,
                                                initStart: task.dateInterval.start!, initDuration: task.dateInterval.duration!, initEnd: task.dateInterval.end!,
                                                indexCountedFromOne: schedule.tasks.firstIndex(of: task)! + 1)
        navigationController?.present(ScheduleEditNavigationViewController(rootViewController: scheduleEditViewController), animated: true, completion: nil)
    }
    
    func toggleFinishStatus(task: Task) {
        if let taskIndex = schedule.tasks.firstIndex(of: task) {
            // Gets the cell tapped.
            var toggledTask = schedule.tasks[taskIndex]
            toggledTask.isFinished.toggle()
                        
            // Updates the task corresponding to the cell.
            let indexPath = IndexPath(row: taskIndex, section: 0)
            let cell = scheduleTableView!.cellForRow(at: indexPath) as! ScheduleTableViewCell
            cell.updateValues(task: toggledTask, scheduleViewController: self)
            
            // Rearranges the cell.
            schedule.tasks[taskIndex].isFinished.toggle()
            if let TaskNewIndex = schedule.tasks.firstIndex(of: toggledTask) {
                let newIndexPath = IndexPath(row: TaskNewIndex, section: 0)
                scheduleTableView.moveRow(at: indexPath, to: newIndexPath)
            }
        }
    }
    
    func editTask(task: Task, indexCountedFromOne: Int?) {
        if let index = indexCountedFromOne {
            if index > 0 {  // Update.
                schedule.tasks[index - 1] = task
            } else {  // Deletion.
                schedule.tasks.remove(at: index * -1 - 1)
            }
        } else {  // Insertion.
            schedule.tasks.append(task)
        }
        
        scheduleTableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScheduleTableViewCell()
        
        var task = schedule.tasks[indexPath.row]
        // Capacity.
        task = Task(content: task.content, dateInterval: Interval(start: task.dateInterval.start, end: task.dateInterval.end), isFinished: task.isFinished)
        schedule.tasks[indexPath.row] = task
        
        cell.updateValues(task: task, scheduleViewController: self)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

extension Schedule {
    var latestUnfinishedTask: Task? {
        if tasks.count == 0 {
            return nil
        }
        
        var latestTask = tasks[0]
        for task in tasks[0..<tasks.count] {
            if task.dateInterval.start! > latestTask.dateInterval.start! {
                latestTask = task
            }
        }
        return latestTask
    }
}
