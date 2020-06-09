//
//  ScheduleViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskEditingDelegate {

    var schedule: Schedule! {
        didSet {
            self.schedule.tasks.sort()
//            drawAdvancementArc()
            
            // Saves to disk.
            Schedule.saveSchedule(self.schedule)
            
            if let committed = self.schedule.committed {
                self.committedBarButton.title = committed ? "🟢" : "🔴"
            } else {
                self.committedBarButton.title = ""
            }
        }
    }
    
    var editable: Bool {
        if schedule.date < Date().dateOfCurrentTimeZone()
            && Calendar(identifier: .gregorian).dateComponents([.day], from: schedule.date, to: Date().dateOfCurrentTimeZone()).day! > 0 {
            return false
        } else {
            return true
        }
    }
    
//    var finishedTaskNumber: Int {
//        schedule.tasks.filter({ (task) -> Bool in
//            task.isFinished
//        }).count
//    }
    
    var latestTask: Task? {
        if schedule.tasks.count == 0 {
            return nil
        }
        
        var latestTask = schedule.tasks[0]
        for task in schedule.tasks[0..<schedule.tasks.count] {
            if task.dateInterval.start > latestTask.dateInterval.start {
                latestTask = task
            }
        }
        return latestTask
    }
    
    // Views.
    var scheduleTableView: UITableView!
    
    var dateButton = UIButton()
    var datePickerView: ScheduleDatePickerView!
    var datePickerViewDisplayed = false
    
    let committedBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    var advancementArcLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        schedule = Schedule.loadSchedule(date: Date().dateOfCurrentTimeZone())
        guard schedule != nil else {
            return
        }
        
        updateViews()

        Thread.detachNewThreadSelector(#selector(checkEditability), toTarget: self, with: nil)
        Thread.detachNewThreadSelector(#selector(checkGithubCommit), toTarget: self, with: nil)
    }
    
    @objc func checkGithubCommit() {
        while true {
            // Makes a request.
            let url = URL(string: "https://github.com/Chunngai")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let string = String(data: data, encoding: .utf8) {
                    let htmlText = string
                    
                    // Gets the value of data-count.
                    let pattern = "data-count=\"(\\d+)\" data-date=\"\(Date().dateOfCurrentTimeZone().formattedLongDate(separator: "-"))\""
                    let regex = try? NSRegularExpression(pattern: pattern, options: [])
                    let res = regex?.firstMatch(in: htmlText, options: [], range: NSRange(location: 0, length: htmlText.count))
                    
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
            
            Thread.sleep(forTimeInterval: 5 * 60)
        }
    }
    
    @objc func checkEditability() {
        while true {
            DispatchQueue.main.async {
                self.verifyEditability()
            }
            
            Thread.sleep(forTimeInterval: 5 * 60)
        }
    }
    
    func updateViews() {
        // Sets the title of the navigation item.
        navigationItem.title = "\(Date().dateOfCurrentTimeZone().formattedDate()) \(Date().dateOfCurrentTimeZone().shortWeekdaySymbol)"

        // Bar buttons.
        let dateBarButton = UIBarButtonItem(title: "Date", style: .plain, target: self, action: #selector(dateBarButtonTapped))
        dateBarButton.tintColor = .white

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
        
        // Advancement arc.
//        view.layer.addSublayer(advancementArcLayer!)
        
        // Date picker.
        datePickerView = ScheduleDatePickerView(frame: CGRect(
            x: 0,
            y: UIScreen.main.bounds.height,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height * 0.5))
        view.addSubview(datePickerView)
        
        datePickerView.updateValues(scheduleViewController: self)
    }
    
    func verifyEditability() {
        if !editable {
            navigationItem.rightBarButtonItem = nil
        } else {
            let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
            addBarButton.tintColor = .white
            navigationItem.rightBarButtonItem = addBarButton
        }
    }
    
    func changeSchedule() {
        Schedule.saveSchedule(schedule)
                    
        let newScheduleDate = datePickerView.datePicker.date.dateOfCurrentTimeZone()
        navigationItem.title = "\(newScheduleDate.formattedDate()) \(newScheduleDate.shortWeekdaySymbol)"
        
        schedule = Schedule.loadSchedule(date: newScheduleDate)!
        guard schedule != nil else {
            return
        }
        scheduleTableView.reloadData()
        
        verifyEditability()
    }
    
    @objc func dateBarButtonTapped() {
        if !datePickerViewDisplayed {
            UIView.animate(withDuration: 0.3) {
                self.datePickerView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height * 0.4)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.datePickerView.transform = CGAffineTransform(translationX: 0, y: +UIScreen.main.bounds.height * 0.4)
            }
        }
        
        datePickerViewDisplayed.toggle()
    }
    
    @objc func presentAddingView() {
        var initStart: Date
        var initDuration: TimeInterval
        var initEnd: Date
        if let latestTask = latestTask {
            initStart = latestTask.dateInterval.end
            initDuration = latestTask.dateInterval.duration
            initEnd = Date(timeInterval: initDuration, since: initStart)
        } else {
            if Date().dateOfCurrentTimeZone() < schedule.date {  // More likely to plan for the next day.
                initStart = Date(hour: 8, minute: 30).dateOfCurrentTimeZone()
                initDuration = 2400
                initEnd = Date(hour: 9, minute: 10).dateOfCurrentTimeZone()
            } else {  // More likely to plan for the current day.
                let calendar = Calendar(identifier: .gregorian)
                let currentHourAndMinute = calendar.dateComponents([.hour, .minute], from: Date())
                let currentHour = currentHourAndMinute.hour!
                let currentMinute = currentHourAndMinute.minute!
        
                initStart = Date(hour: currentHour, minute: currentMinute).dateOfCurrentTimeZone()
                initDuration = 2400
                initEnd = Date(timeInterval: initDuration, since: initStart)
            }
        }
                
        let scheduleEditViewController = ScheduleEditViewController()
        scheduleEditViewController.updateValues(scheduleViewController: self, task: Task(),
                                                initStart: initStart, initDuration: initDuration, initEnd: initEnd,
                                                indexCountedFromOne: nil)
        navigationController?.present(ScheduleEditNavigationViewController(rootViewController: scheduleEditViewController), animated: true, completion: nil)
    }
    
    func presentEditingView(task: Task) {
        let scheduleEditViewController = ScheduleEditViewController()
        scheduleEditViewController.updateValues(scheduleViewController: self, task: task,
                                                initStart: task.dateInterval.start, initDuration: task.dateInterval.duration, initEnd: task.dateInterval.end,
                                                indexCountedFromOne: schedule.tasks.firstIndex(of: task)! + 1)
        navigationController?.present(ScheduleEditNavigationViewController(rootViewController: scheduleEditViewController), animated: true, completion: nil)
    }
    
    func toggleFinishStatus(task: Task) {
        if let taskIndex = schedule.tasks.firstIndex(of: task) {
            var toggledTask = schedule.tasks[taskIndex]
            toggledTask.isFinished.toggle()
            
            schedule.tasks[taskIndex].isFinished.toggle()
            
            let indexPath = IndexPath(row: taskIndex, section: 0)
            let cell = scheduleTableView!.cellForRow(at: indexPath) as! ScheduleTableViewCell
            cell.updateValues(task: toggledTask, scheduleViewController: self)
            
            if let TaskNewIndex = schedule.tasks.firstIndex(of: toggledTask) {
                let newIndexPath = IndexPath(row: TaskNewIndex, section: 0)
                scheduleTableView.moveRow(at: indexPath, to: newIndexPath)
            }
        }
    }
    
//    func drawAdvancementArc() {
//        var ratio: CGFloat = 0
//        if schedule.tasks.count != 0 {
//            ratio = CGFloat(Double(finishedTaskNumber) / Double(schedule!.tasks.count))
//        }
//
//        let advancementArcRadius: CGFloat = 16
//        let advancementArcCenterX: CGFloat = view.bounds.width - 28
//        let advancementArcCenterY: CGFloat = navigationController!.navigationBar.bounds.maxY + advancementArcRadius
//
//        let advancementArcPath = UIBezierPath(arcCenter: CGPoint(x: advancementArcCenterX, y: CGFloat(advancementArcCenterY)), radius: advancementArcRadius, startAngle: .pi * 1.5, endAngle: .pi * 2 * ratio + .pi * 1.5, clockwise: true)
//
//        advancementArcLayer.path = advancementArcPath.cgPath
//        advancementArcLayer.fillColor = nil
//        advancementArcLayer.strokeColor = UIColor.white.cgColor
//        advancementArcLayer.lineWidth = 2
//        advancementArcLayer.setNeedsDisplay()
//    }
    
    func editTask(task: Task, indexCountedFromOne: Int?) {
        if let index = indexCountedFromOne {
            if index > 0 {
                schedule.tasks[index - 1] = task
            } else {
                schedule.tasks.remove(at: index * -1 - 1)
            }
        } else {
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
        cell.updateValues(task: schedule.tasks[indexPath.row], scheduleViewController: self)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}
