//
//  AssignmentsViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView?
    let assignmentCellReuseIdentifier = "AssignmentCell"
    
    var courses: [Course]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = Course.loadCourses() ?? Course.sampleCourses
        
        updateView()
    }
    
    func updateView() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        // Customizes the navigation bar
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.setToTransparent()
        
        // Sets titles
        navigationItem.title = "Assignments"
        
        navigationController?.tabBarItem.title = "Assignments"
        
        // Creates a segmented controller
        let segmentedControl = UISegmentedControl(items: ["Course", "Due Date"])
        
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
        
        view.addSubview(segmentedControl)
        
        // Creates a table view
        let tableViewX: CGFloat = 0
        let tableViewY = navigationBar.bounds.maxY + navigationBar.bounds.height
        let tableViewWidth = view.bounds.width
        let tableViewHeight = view.bounds.height - tableViewY
        tableView = UITableView(frame: CGRect(x: tableViewX, y: tableViewY, width: tableViewWidth, height: tableViewHeight), style: .grouped)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.separatorStyle = .none
        
        tableView?.register(AssignmentTableViewCell.classForCoder(), forCellReuseIdentifier: assignmentCellReuseIdentifier)
                
        view.addSubview(tableView!)
    }
    
    @objc func segmentDidChanged(_ sender: UISegmentedControl) {
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courses!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses!.activeCourseIndices[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: assignmentCellReuseIdentifier, for: indexPath) as! AssignmentTableViewCell
                
        cell.backgroundColor = tableView.backgroundColor
        
        let assignment = courses!.getAssignment(indexPath: indexPath)
        cell.updateValues(assignment: assignment)
        
        return cell
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return courses![section].name
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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

extension Array where Element == Course {
    func getAssignment(indexPath: IndexPath) -> Task {
        let assignmentIndex = self.activeCourseIndices[indexPath.section][indexPath.row]
        
        return self[indexPath.section].assignments[assignmentIndex]
    }
}
