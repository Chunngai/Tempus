//
//  ScheduleViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskEditingDelegate {

    // Data source.
    var schedule: Schedule? {
        didSet {
            self.schedule?.tasks.sort()
            drawAdvancementArc()
            
            // Saves to disk.
            Schedule.saveSchedule(self.schedule!)
            
            if let scheduleDate = self.schedule?.date.formattedDate(),
                scheduleDate < Date().GMT8().formattedDate() {
                isScheduleBeforeToday = true
            } else {
                isScheduleBeforeToday = false
            }
        }
    }
    
    var isScheduleBeforeToday: Bool?
    
    var finishedTaskNumber: Int {
        schedule!.tasks.filter({ (task) -> Bool in
            task.isFinished
            }).count
    }
    
    var latestTask: Task? {
        if schedule!.tasks.count == 0 {
            return nil
        }
        
        var latestTask = schedule!.tasks[0]
        for task in schedule!.tasks[0..<schedule!.tasks.count] {
            if task.dateInterval.start > latestTask.dateInterval.start {
                latestTask = task
            }
        }
        return latestTask
    }
    
    // Views.
    var scheduleTableView: UITableView?
    
    var dateButton: UIButton!
    var datePickerView: ScheduleDatePickerView!
    var datePickerViewDisplayed: Bool!
    
    var advancementArcLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        updateViews()

        schedule = Schedule.loadSchedule(date: Date().GMT8())
    }
    
    func updateViews() {
        // Sets the title of the navigation item.
        navigationItem.title = "\(Date().GMT8().formattedDate()) \(Date().GMT8().shortWeekdaySymbol)"
        // Button to diGMT8y and change the date.
//        dateButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.03, y: navigationController!.navigationBar.bounds.maxY + 40, width: 100, height: 30))
//        view.addSubview(dateButton)
        
//        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
//        dateButton.backgroundColor = .aqua
//        dateButton.setTitle("\(Date().GTM8().formattedDate()) \(Date().GTM8().shortWeekdaySymbol)", for: .normal)

        let dateBarButton = UIBarButtonItem(title: "Date", style: .plain, target: self, action: #selector(dateButtonTapped))
        dateBarButton.tintColor = .white
        navigationItem.leftBarButtonItem = dateBarButton
        
        // Adds button.
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
        addBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = addBarButton
        
//        let view_ = UIView()
//        view.addSubview(view_)
        
        // Adds a table view.
        scheduleTableView = UITableView(frame:
            CGRect(
//                x: 0,
//                   y: navigationController!.navigationBar.frame.maxY
//                    + navigationController!.navigationBar.frame.height,
//                   width: view.frame.width,
//                   height: view.frame.height
//                    - (navigationController!.navigationBar.frame.maxY
//                        + navigationController!.navigationBar.frame.height)
            x: 0,
            y: navigationController!.navigationBar.frame.height,
            width: view.frame.width,
            height: view.frame.height - navigationController!.navigationBar.frame.height - tabBarController!.tabBar.frame.height
            ), style: .grouped)
        view.addSubview(scheduleTableView!)

        scheduleTableView?.dataSource = self
        scheduleTableView?.delegate = self
        
        scheduleTableView?.register(ScheduleTableViewCell.classForCoder(), forCellReuseIdentifier: "ScheduleTableViewCell")
        
        scheduleTableView?.backgroundColor = UIColor.sky.withAlphaComponent(0)
        scheduleTableView?.separatorStyle = .none
        
        scheduleTableView?.estimatedRowHeight = 120
        scheduleTableView?.rowHeight = UITableView.automaticDimension
        
        // Draws advancement arc.
        advancementArcLayer = CAShapeLayer()
//        view.layer.addSublayer(advancementArcLayer!)
        
        // Adds date picker.
        datePickerView = ScheduleDatePickerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5))
        view.addSubview(datePickerView)
        
        datePickerView.scheduleViewController = self
        datePickerViewDisplayed = false
    }
    
    @objc func dateButtonTapped() {
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
        
//        if !datePickerViewDisplayed {
////            if scheduleToDisplay.date != Date().GTM8() {
//            Schedule.saveSchedule(self.schedule!)
//                        
//            let dateOfScheduleToDisplay = datePickerView.datePicker.date.GTM8()
//            let scheduleToDisplay = Schedule.loadSchedule(date: dateOfScheduleToDisplay)!
//            self.schedule = scheduleToDisplay
//            dateButton.setTitle(scheduleToDisplay.date.formattedDate(), for: .normal)
//            
//            if isScheduleBeforeToday! {
//                navigationItem.rightBarButtonItem = nil
//            } else {
//                let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
//                addBarButton.tintColor = .white
//                navigationItem.rightBarButtonItem = addBarButton
//            }
//            
//            scheduleTableView?.reloadData()
////            }
//        }
                
//        Schedule.saveSchedule(self.schedule!)
//
//        let today = Date().GTM8()
//        let tomorrow = Date(timeInterval: 24 * 3600, since: today)
//        if schedule!.date.formattedDate() == today.formattedDate() {
//            schedule = Schedule.loadSchedule(date: tomorrow)
//
//            dateButton.setTitle(tomorrow.formattedDate(), for: .normal)
//        } else {
//            schedule = Schedule.loadSchedule(date: today)
//
//            dateButton.setTitle(today.formattedDate(), for: .normal)
//        }
//
//        scheduleTableView?.reloadData()
    }
    
    func changeSchedule() {
        Schedule.saveSchedule(self.schedule!)
                    
        let dateOfScheduleToDisplay = datePickerView.datePicker.date.GMT8()
        navigationItem.title = "\(dateOfScheduleToDisplay.formattedDate()) \(dateOfScheduleToDisplay.shortWeekdaySymbol)"
        
        let scheduleToDisplay = Schedule.loadSchedule(date: dateOfScheduleToDisplay)!
        self.schedule = scheduleToDisplay

        if isScheduleBeforeToday! {
            navigationItem.rightBarButtonItem = nil
        } else {
            let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
            addBarButton.tintColor = .white
            navigationItem.rightBarButtonItem = addBarButton
        }
        
        scheduleTableView?.reloadData()
    }
    
    @objc func presentAddingView() {
        let scheduleEditViewController = ScheduleEditViewController_()
        
        scheduleEditViewController.scheduleViewController = self
        scheduleEditViewController.task = Task()
        if let latestTask = latestTask {
            let initStart = latestTask.dateInterval.end
            let initDuration = latestTask.dateInterval.duration
            
            scheduleEditViewController.initStart = initStart
            scheduleEditViewController.initDuration = initDuration
            scheduleEditViewController.initEnd = Date(timeInterval: initDuration, since: initStart)
        } else {
            scheduleEditViewController.initStart = nil
            scheduleEditViewController.initDuration = nil
            scheduleEditViewController.initEnd = nil	
        }
        scheduleEditViewController.indexCountedFromOne = nil
                
//        navigationController?.pushViewController(scheduleEditViewController, animated: true)
        navigationController?.present(ScheduleEditNavigationViewController(rootViewController: scheduleEditViewController), animated: true, completion: nil)
    }
    
    func presentEditingView(task: Task) {
        let scheduleEditViewController = ScheduleEditViewController_()
        
        scheduleEditViewController.scheduleViewController = self
        scheduleEditViewController.task = task
        scheduleEditViewController.initStart = task.dateInterval.start
        scheduleEditViewController.initDuration = task.dateInterval.duration
        scheduleEditViewController.initEnd = task.dateInterval.end
        scheduleEditViewController.indexCountedFromOne = schedule!.tasks.firstIndex(of: task)! + 1
                
//        navigationController?.pushViewController(scheduleEditViewController, anima
        navigationController?.present(ScheduleEditNavigationViewController(rootViewController: scheduleEditViewController), animated: true, completion: nil)
    }
    
    func toggleFinishStatus(task: Task) {
        let index = schedule?.tasks.firstIndex(of: task)
        
        if let index = index {
            var toggledTask = schedule!.tasks[index]
            toggledTask.isFinished.toggle()
            
            schedule!.tasks[index].isFinished.toggle()
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell = scheduleTableView!.cellForRow(at: indexPath) as! ScheduleTableViewCell
            cell.updateValues(task: toggledTask, delegate: self)
            
            let idx = schedule?.tasks.firstIndex(of: toggledTask)
            let newIndexPath = IndexPath(row: idx!, section: 0)
            scheduleTableView?.moveRow(at: indexPath, to: newIndexPath)
        }
    }
    
    func drawAdvancementArc() {
        var ratio: CGFloat = 0
        if schedule!.tasks.count != 0 {
            ratio = CGFloat(Double(finishedTaskNumber) / Double(schedule!.tasks.count))
        }
        
        let advancementArcRadius: CGFloat = 16
        let advancementArcCenterX: CGFloat = view.bounds.width - 28
        let advancementArcCenterY: CGFloat = navigationController!.navigationBar.bounds.maxY + advancementArcRadius
        
        let advancementArcPath = UIBezierPath(arcCenter: CGPoint(x: advancementArcCenterX, y: CGFloat(advancementArcCenterY)), radius: advancementArcRadius, startAngle: .pi * 1.5, endAngle: .pi * 2 * ratio + .pi * 1.5, clockwise: true)
        
        advancementArcLayer?.path = advancementArcPath.cgPath
        advancementArcLayer?.fillColor = nil
        advancementArcLayer?.strokeColor = UIColor.white.cgColor
        advancementArcLayer?.lineWidth = 2
        advancementArcLayer?.setNeedsDisplay()
    }
    
    func editTask(task: Task, indexCountedFromOne: Int?) {
        if let index = indexCountedFromOne {
            if index > 0 {
                schedule?.tasks[index - 1] = task
            } else {
                schedule?.tasks.remove(at: index * -1 - 1)
            }
        } else {
            schedule?.tasks.append(task)
        }
        
        scheduleTableView?.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule!.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScheduleTableViewCell()
        
        cell.updateValues(task: schedule!.tasks[indexPath.row], delegate: self)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var toggledTask = schedule!.tasks[indexPath.row]
//        toggledTask.isFinished.toggle()
//
//        schedule!.tasks[indexPath.row].isFinished.toggle()
//
//        let cell = tableView.cellForRow(at: indexPath) as! ScheduleTableViewCell
//        cell.updateValues(task: toggledTask, delegate: self)
//
//        let idx = schedule?.tasks.firstIndex(of: toggledTask)
//        let newIndexPath = IndexPath(row: idx!, section: 0)
//        scheduleTableView?.moveRow(at: indexPath, to: newIndexPath)
////        scheduleTableView?.reloadData()
//    }
}
