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
    
    var courses: [Course]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = Course.loadCourses() ?? Course.sampleCourses
        
        updateView()
    }
    
    func updateView() {
        let navigationBar = navigationController!.navigationBar
        
        // Customizes the navigation bar
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.setToTransparent()
        
        // Sets titles
        navigationItem.title = "Assignments"
        
        navigationController?.tabBarItem.title = "Assignments"
        
        // Creates a segmented controller
        let segmentedControl = UISegmentedControl(items: ["Course", "Due Date"])
        view.addSubview(segmentedControl)
        
        let segmentedControllerWidth: CGFloat = 200
        let segmentedControllerHeight: CGFloat = 25
        let segmentedControllerX = view.bounds.width / 2 - segmentedControllerWidth / 2
        let segmentedControllerY = navigationBar.bounds.midY + navigationBar.bounds.height
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
        let tableViewY = navigationBar.bounds.maxY + navigationBar.bounds.height
        let tableViewWidth = view.bounds.width
        let tableViewHeight = view.bounds.height - tableViewY
        tableView = UITableView(frame: CGRect(x: tableViewX, y: tableViewY, width: tableViewWidth, height: tableViewHeight), style: .grouped)
        view.addSubview(tableView!)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.separatorStyle = .none
        
        tableView?.register(AssignmentTableViewCell.classForCoder(), forCellReuseIdentifier: assignmentCellReuseIdentifier)
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
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return courses![section].name
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
