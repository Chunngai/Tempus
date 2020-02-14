//
//  AssignmentsViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AssignmentTableViewCellDelegate {
    
    var tableView: UITableView?
    let assignmentCellReuseIdentifier = "AssignmentCell"
    let assignmentHeaderViewReuseIdentifier = "AssignmentSection"
    
    var navigationBar: UINavigationBar?
    var navigationBarWithoutLargeTitleFrameHeight: CGFloat?
    
    var advancementArcLayer: CAShapeLayer?
    
    var dueDateNotBeforeTodayAndFinishedAssignmentNumber: Int {
        var dueDateNotBeforeTodayAndFinishedAssignmentNumber = 0
        
        for course in courses! {
            dueDateNotBeforeTodayAndFinishedAssignmentNumber += course.dueDateNotBeforeTodayAndFinishedAssignmentNumber
        }
        
        return dueDateNotBeforeTodayAndFinishedAssignmentNumber
    }
    var dueDateNotBeforeTodayOrUnfinishedAssignmentNumber : Int {
        var dueDateNotBeforeTodayOrUnfinishedAssignmentNumber = 0
    
        for course in courses! {
            dueDateNotBeforeTodayOrUnfinishedAssignmentNumber += course.dueDateNotBeforeTodayOrUnfinishedAssignmentNumber
        }
        
        return dueDateNotBeforeTodayOrUnfinishedAssignmentNumber
    }
    var availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber: Int {
        var availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber = 0
        
        for course in courses! {
            availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber += course.availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber
        }
        
        return availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber
    }
    
    var dueDateNotBeforeTodayAndFinishedAssignmentRatio: CGFloat {
        return CGFloat(dueDateNotBeforeTodayAndFinishedAssignmentNumber) / CGFloat(dueDateNotBeforeTodayOrUnfinishedAssignmentNumber)
    }
    
    var courses: [Course]? {
        didSet {
            if availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber > 0 {
            navigationController?.tabBarItem.badgeValue = String(availableTimeLessThanThreeDaysAndNotFinishedAssignmentNumber)
            } else {
                navigationController?.tabBarItem.badgeValue = nil
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = Course.loadCourses() ?? Course.sampleCourses
        
        updateView()
    }
        
    func updateView() {
        navigationBar = navigationController!.navigationBar
        
        // Customizes the navigation bar
        navigationBar!.prefersLargeTitles = true
        navigationBar!.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBarWithoutLargeTitleFrameHeight = navigationBar!.frame.maxY
        
        navigationBar!.setToTransparent()
        
        // Sets titles
        navigationItem.title = "Assignments"
        
        navigationController?.tabBarItem.title = "Assignments"
        
        // Creates an advancement icon
        advancementArcLayer = CAShapeLayer()
        drawAdvancementArc(ratio: dueDateNotBeforeTodayAndFinishedAssignmentRatio)
        
        // Creates a segmented controller
        let segmentedControl = UISegmentedControl(items: ["Course", "Due Date"])
        view.addSubview(segmentedControl)
        
        let segmentedControllerWidth: CGFloat = 200
        let segmentedControllerHeight: CGFloat = 25
        let segmentedControllerX = view.bounds.width / 2 - segmentedControllerWidth / 2
        let segmentedControllerY = navigationBar!.bounds.midY + navigationBar!.bounds.height
        segmentedControl.frame = CGRect(x: segmentedControllerX, y: segmentedControllerY,
                                        width: segmentedControllerWidth, height: segmentedControllerHeight)
        
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.aqua], for: .selected)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.backgroundColor = UIColor().withAlphaComponent(0)
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentDidChanged(_:)), for: .valueChanged)
                
        // Creates a table view
        let tableViewX: CGFloat = 0
        let tableViewY = navigationBar!.bounds.maxY + navigationBar!.bounds.height
        let tableViewWidth = view.bounds.width
        let tableViewHeight = view.bounds.height - tableViewY
        tableView = UITableView(frame: CGRect(x: tableViewX, y: tableViewY, width: tableViewWidth, height: tableViewHeight), style: .grouped)
        view.addSubview(tableView!)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.separatorStyle = .none
        
        tableView?.register(AssignmentTableViewCell.classForCoder(), forCellReuseIdentifier: assignmentCellReuseIdentifier)
        tableView?.register(AssignmentTableViewHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: assignmentHeaderViewReuseIdentifier)
    }
    
    func drawAdvancementArc(ratio: CGFloat) {
        let advancementArcRadius: CGFloat = 16
        let advancementArcCenterX: CGFloat = view.bounds.width - 50
        let advancementArcCenterY: CGFloat = navigationBarWithoutLargeTitleFrameHeight! + advancementArcRadius
        let advancementArcPath = UIBezierPath(arcCenter: CGPoint(x: advancementArcCenterX, y: advancementArcCenterY), radius: advancementArcRadius, startAngle: .pi * 1.5, endAngle:  .pi * 2 * ratio + .pi * 1.5
            , clockwise: true)
        
        view.layer.addSublayer(advancementArcLayer!)

        advancementArcLayer!.path = advancementArcPath.cgPath
        advancementArcLayer!.fillColor = nil
        advancementArcLayer!.strokeColor = UIColor.white.cgColor
        advancementArcLayer!.lineWidth = 2
        advancementArcLayer!.setNeedsDisplay()
    }
    
    @objc func segmentDidChanged(_ sender: UISegmentedControl) {
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courses!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses![section].dueDateNotBeforeTodayOrUnfinishedAssignmentNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: assignmentCellReuseIdentifier, for: indexPath) as! AssignmentTableViewCell
        let cell = AssignmentTableViewCell()
                        
        let assignment = courses![indexPath.section].assignments[indexPath.row]
        cell.updateValues(assignment: assignment, tableViewBackgroundColor: tableView.backgroundColor, delegate: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: assignmentHeaderViewReuseIdentifier) as! AssignmentTableViewHeaderView
        
        let course = courses![section]
        headerView.updateValues(course: course)
        
        return headerView
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return courses![section].name
//    }
        
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AssignmentTableViewCell
        cell.viewTapped()
    }
    
    // MARK: - Assignment table view cell delegate
    func toggleFinishStatus(assignment: Task) {
        let indexPathForSelectedRow = tableView!.indexPathForSelectedRow!
        let section = indexPathForSelectedRow.section
        let row = indexPathForSelectedRow.row
        
        if !assignment.isOverDue {
            courses![section].assignments[row] = assignment
            if assignment.isFinished {
                let numberOfRowsInSection = tableView!.numberOfRows(inSection: section)
                let indexPathForLastRowInSection = IndexPath(row: numberOfRowsInSection - 1, section: section)
                
                courses![section].assignments.remove(at: row)
                courses![section].assignments.insert(assignment, at: numberOfRowsInSection - 1)
                
                tableView?.moveRow(at: indexPathForSelectedRow, to: indexPathForLastRowInSection)
            } else {
                courses![section].sortAssignmentsByDueDateAndTimeAvailable()
                let newIndex = courses![section].assignments.firstIndex(of: assignment)!
                let indexPathForNewRow = IndexPath(row: newIndex, section: section)
                
                tableView?.moveRow(at: indexPathForSelectedRow, to: indexPathForNewRow)
            }
        } else {
            courses![section].assignments.remove(at: row)
            courses![section].assignments.append(assignment)
            
            tableView?.deleteRows(at: [indexPathForSelectedRow], with: .automatic)
        }
                
        if let headerView = tableView!.headerView(forSection: section) as? AssignmentTableViewHeaderView {
            headerView.updateValues(course: courses![section])
        }
        
        
        drawAdvancementArc(ratio: dueDateNotBeforeTodayAndFinishedAssignmentRatio)
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
