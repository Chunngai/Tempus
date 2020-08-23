//
//  CourseEditViewController.swift
//  Tempus
//
//  Created by Sola on 2020/8/22.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Models
    
    var course: Course!
    
    // MARK: - Controllers
    
    var delegate: CourseViewController!
    
    // MARK: - Views
    
    lazy var courseEditTableView: UITableView = {
        var tableView = UITableView()
        
        tableView = UITableView(
            frame: CGRect(x: 0,
                          y: navigationController!.navigationBar.frame.height,
                          width: view.frame.width,
                          height: view.frame.height
                            - navigationController!.navigationBar.frame.height),
            style: .plain
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor.sky.withAlphaComponent(0)
//        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateInitialViews()
    }
    
    // MARK: - Customized init
    
    func updateInitialViews() {
        // Background.
        view.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        
        // Title.
        navigationItem.title = "Detail"
        
        // Bar button items.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
        // Table view.
        view.addSubview(courseEditTableView)
    }
    
    func updateValues(delegate: CourseViewController, course: Course) {
        self.delegate = delegate
        
        self.course = course
    }
    
    // MARK: - Customized funcs
    
    @objc func cancelButtonTapped() {
        delegate.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
//        print(getCell(at: courseNameCellIndexPath).textField)
    }
    
    func getLabelText(at indexPath: IndexPath) -> String {
        return ""
    }
    
    func getValidIntegers(at indexPath: IndexPath) -> ClosedRange<Int> {
        return 1...100
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + course.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CourseEditTextTableViewCell()
        cell.updateValues(labelText: getLabelText(at: indexPath), validIntegers: getValidIntegers(at: indexPath))
        return cell
    }
}

extension CourseEditViewController {
//    var courseNameCellIndexPath: IndexPath {
//        return IndexPath(row: 0, section: 0)
//    }
//    var instructorCellIndexPath: IndexPath {
//        return IndexPath(row: 1, section: 0)
//    }
//    var weekNumberCellIndexPath: IndexPath {
//        return IndexPath(row: 2, section: 0)
//    }
//
//    var weekdayCellIndexPath: IndexPath {
//        return IndexPath(row: 0, section: 2)
//    }
//    var startCellIndexPath: IndexPath {
//        return IndexPath(row: 1, section: 2)
//    }
//    var endCellIndexPath: IndexPath {
//        return IndexPath(row: 2, section: 2)
//    }
//    var classroomCellIndexPath: IndexPath {
//        return IndexPath(row: 3, section: 2)
//    }
//
//    var labelTexts: [IndexPath: String] {
//        return [
//            courseNameCellIndexPath: "Course",
//            instructorCellIndexPath: "Instructor",
//            weekNumberCellIndexPath: "Weeks",
//
//            weekdayCellIndexPath: "On",
//            startCellIndexPath: "From Section",
//            endCellIndexPath: "To Section",
//            classroomCellIndexPath: "At"
//        ]
//    }
//
//    var validIntegers: [IndexPath: ClosedRange<Int>] {
//        return [
//            weekNumberCellIndexPath: 1...16,
//
//            weekdayCellIndexPath: 1...7,
//            startCellIndexPath: 1...15,
//            endCellIndexPath: 1...15,
//        ]
//    }
    
    func getCell(at indexPath: IndexPath) -> CourseEditTextTableViewCell {
        return courseEditTableView.cellForRow(at: indexPath) as! CourseEditTextTableViewCell
    }
}
