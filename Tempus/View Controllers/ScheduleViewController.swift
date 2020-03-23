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
        }
    }
    var finishedTaskNumber: Int {
        schedule!.tasks.filter({ (task) -> Bool in
            task.isFinished
            }).count
    }
    
    // Views.
    var scheduleTableView: UITableView?
    
    var dateButton: UIButton!
    
    var advancementArcLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        updateViews()

        schedule = Schedule.loadSchedule(date: Date().GTM8())
    }
    
    func updateViews() {
        // Sets the title of the navigation item.
        navigationItem.title = "Schedule"
        
        // Button to display and change the date.
        dateButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.03, y: navigationController!.navigationBar.bounds.maxY + 40, width: 60, height: 30))
        view.addSubview(dateButton)
        
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
//        dateButton.backgroundColor = .aqua
        dateButton.setTitle(Date().GTM8().formattedDate(), for: .normal)
        
        // Add button.
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
        addBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = addBarButton
        
//        let view_ = UIView()
//        view.addSubview(view_)
        
        // Adds a table view.
        scheduleTableView = UITableView(frame:
            CGRect(x: 0,
                   y: navigationController!.navigationBar.frame.maxY
                    + navigationController!.navigationBar.frame.height,
                   width: view.frame.width,
                   height: view.frame.height
                    - (navigationController!.navigationBar.frame.maxY
                        + navigationController!.navigationBar.frame.height)), style: .grouped)
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
        view.layer.addSublayer(advancementArcLayer!)
    }
    
    @objc func dateButtonTapped() {
        Schedule.saveSchedule(self.schedule!)
        
        let today = Date().GTM8()
        let tomorrow = Date(timeInterval: 24 * 3600, since: today)
        if schedule!.date.formattedDate() == today.formattedDate() {
            schedule = Schedule.loadSchedule(date: tomorrow)
            
            dateButton.setTitle(tomorrow.formattedDate(), for: .normal)
        } else {
            schedule = Schedule.loadSchedule(date: today)
            
            dateButton.setTitle(today.formattedDate(), for: .normal)
        }
        
        scheduleTableView?.reloadData()
    }
    
    @objc func presentAddingView() {
        let scheduleEditTimeTableViewController = ScheduleEditTimeTableViewController()
        
        scheduleEditTimeTableViewController.scheduleViewController = self
        scheduleEditTimeTableViewController.task = Task()
        scheduleEditTimeTableViewController.initStart = schedule?.tasks.last?.dateInterval.end
        scheduleEditTimeTableViewController.initDuration = schedule?.tasks.last?.dateInterval.duration
        scheduleEditTimeTableViewController.initEnd = schedule?.tasks.last?.dateInterval.end
        scheduleEditTimeTableViewController.idx = -1
                
        navigationController?.present(ScheduleEditNavigationViewController(rootViewController: scheduleEditTimeTableViewController), animated: true)
    }
    
    func presentEditingView(task: Task) {
        let scheduleEditTimeTableViewController = ScheduleEditTimeTableViewController()
        
        scheduleEditTimeTableViewController.scheduleViewController = self
        scheduleEditTimeTableViewController.task = task
        scheduleEditTimeTableViewController.initStart = task.dateInterval.start
        scheduleEditTimeTableViewController.initDuration = task.dateInterval.duration
        scheduleEditTimeTableViewController.initEnd = task.dateInterval.end
        scheduleEditTimeTableViewController.idx = schedule!.tasks.firstIndex(of: task)!
                
        navigationController?.present(ScheduleEditNavigationViewController(rootViewController: scheduleEditTimeTableViewController), animated: true)
    }
    
    func drawAdvancementArc() {
        var ratio: CGFloat = 0
        if schedule!.tasks.count != 0 {
            ratio = CGFloat(Double(finishedTaskNumber) / Double(schedule!.tasks.count))
        }
        
        let advancementArcRadius: CGFloat = 16
        let advancementArcCenterX: CGFloat = view.bounds.width - 50
        let advancementArcCenterY: CGFloat = navigationController!.navigationBar.bounds.maxY + advancementArcRadius
        
        let advancementArcPath = UIBezierPath(arcCenter: CGPoint(x: advancementArcCenterX, y: CGFloat(advancementArcCenterY)), radius: advancementArcRadius, startAngle: .pi * 1.5, endAngle: .pi * 2 * ratio + .pi * 1.5, clockwise: true)
        
        advancementArcLayer?.path = advancementArcPath.cgPath
        advancementArcLayer?.fillColor = nil
        advancementArcLayer?.strokeColor = UIColor.white.cgColor
        advancementArcLayer?.lineWidth = 2
        advancementArcLayer?.setNeedsDisplay()
    }
    
    func editTask(task: Task, index: Int) {
        if index == -1 {
            schedule?.tasks.append(task)
        } else if index == -2 {
            if let idx = schedule?.tasks.firstIndex(of: task) {
                schedule?.tasks.remove(at: idx)
            }
        } else {
            schedule?.tasks[index] = task
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var toggledTask = schedule!.tasks[indexPath.row]
        toggledTask.isFinished.toggle()
        
        schedule!.tasks[indexPath.row].isFinished.toggle()
        
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleTableViewCell
        cell.updateValues(task: toggledTask, delegate: self)
        
        let idx = schedule?.tasks.firstIndex(of: toggledTask)
        let newIndexPath = IndexPath(row: idx!, section: 0)
        scheduleTableView?.moveRow(at: indexPath, to: newIndexPath)
//        scheduleTableView?.reloadData()
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
