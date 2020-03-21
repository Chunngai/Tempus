//
//  ScheduleViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/17.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Data source.
    var schedule: Schedule? {
        didSet {
            self.schedule?.tasks.sort()
            drawAdvancementArc()
        }
    }
    var finishedTaskNumber: Int {
        schedule!.tasks.filter({ (task) -> Bool in
            task.isFinished
            }).count
    }
    
    // Views.
    var scheduleTableView: UITableView?
    
    var advancementArcLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        updateViews()

        schedule = Schedule.loadSchedule() ?? Schedule.sampleSchedule
    }
    
    func updateViews() {
        // Sets the title of the navigation item.
        navigationItem.title = "Schedule \(Date().formattedDate())"
        
        // Add button.
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentDetailTable))
        addBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = addBarButton
        
        let view_ = UIView()
        view.addSubview(view_)
        
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
        
        scheduleTableView?.backgroundColor = .white
        scheduleTableView?.separatorStyle = .none
        
        scheduleTableView?.estimatedRowHeight = 120
        scheduleTableView?.rowHeight = UITableView.automaticDimension
        
        // Draws advancement arc.
        advancementArcLayer = CAShapeLayer()
        view.layer.addSublayer(advancementArcLayer!)
    }
    
    @objc func presentDetailTable() {
        navigationController?.present(ScheduleDetailNavigationViewController(rootViewController: ScheduleDetailTableViewController()), animated: true)
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

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule!.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScheduleTableViewCell()
        
        cell.updateValues(task: schedule!.tasks[indexPath.row])

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
        cell.updateValues(task: toggledTask)
        
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
