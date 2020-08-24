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
    
    var courseIndex: Int?
    
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
    
    func updateValues(delegate: CourseViewController, course: Course, courseIndex: Int?) {
        self.delegate = delegate
        
        self.courseIndex = courseIndex
        
        self.course = course
    }
    
    // MARK: - Customized funcs
    
    @objc func cancelButtonTapped() {
        delegate.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        course.name = getTextFieldText(at: IndexPath(row: 0, section: 0))
        course.instructor = getTextFieldText(at: IndexPath(row: 1, section: 0))
        let weekNumberCellIndexPath = IndexPath(row: 2, section: 0)
        if let weekNumber = validateInteger(at: weekNumberCellIndexPath) {
            course.weekNumber = weekNumber
        } else {
//            getCell(at: weekNumberCellIndexPath).switchToWarningColor()
            return
        }
        
        
        for section in 1..<courseEditTableView.numberOfSections {
            let weekdayCellIndexPath = IndexPath(row: 0, section: section)
            if let weekday = validateInteger(at: weekdayCellIndexPath) {
                course.sections[section - 1].weekday = weekday
            } else {
//                getCell(at: weekdayCellIndexPath).switchToWarningColor()
                return
            }
            
            let startCellIndexPath = IndexPath(row: 1, section: section)
            if let start = validateInteger(at: startCellIndexPath) {
                course.sections[section - 1].start = start
            } else {
//                getCell(at: startCellIndexPath).switchToWarningColor()
                return
            }
            
            let endCellIndexPath = IndexPath(row: 2, section: section)
            if let end = validateInteger(at: endCellIndexPath) {
                course.sections[section - 1].end = end
            } else {
//                getCell(at: endCellIndexPath).switchToWarningColor()
                return
            }
            
            course.sections[section - 1].classroom = getTextFieldText(at: IndexPath(row: 3, section: section))
        }
        
        delegate.editCourse(course, at: courseIndex)
        delegate.dismiss(animated: true, completion: nil)
    }
    
    func validateInteger(at indexPath: IndexPath) -> Int? {
        let validIntegers = getValidIntegersForCell(at: indexPath)!
        if let currentValue = Int(getTextFieldText(at: indexPath)),
            validIntegers.contains(currentValue) {
            return Int(currentValue)
        } else {
            return nil
        }
    }
    
    func invalidNumberWarning(withText: String, withRange: ClosedRange<Int>) {
        
    }
    
    func getLabelTextForCell(at indexPath: IndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        
        var labelText = ""
        if section == 0 {
            if row == 0 {
                labelText = "Course"
            } else if row == 1 {
                labelText = "Instructor"
            } else if row == 2 {
                labelText = "Weeks"
            }
        } else {
            if row == 0 {
                labelText = "On"
            } else if row == 1 {
                labelText = "from Section"
            } else if row == 2 {
                labelText = "to Section"
            } else if row == 3 {
                labelText = "At"
            }
        }
        if !labelText.isEmpty {
            labelText += ": "
        }
        
        return labelText
    }
    
    func getValidIntegersForCell(at indexPath: IndexPath) -> ClosedRange<Int>? {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && row == 2 {
            return 1...16
        }
        
        if section != 0 && row == 0 {
            return 1...7
        }
        
        if section != 0 && (row == 1 || row == 2) {
            return 1...15
        }
        
        return nil
    }
    
    func getTextFieldTextForCell(at indexPath: IndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                return course.name
            } else if row == 1 {
                return course.instructor
            } else if row == 2 {
                return course.weekNumber != 0 ? String(course.weekNumber) : ""
            }
        } else {
            let section = course.sections[section - 1]
            
            if row == 0 {
                return section.weekday != 0 ? String(section.weekday) : ""
            } else if row == 1 {
                return section.start != 0 ? String(section.start) : ""
            } else if row == 2 {
                return section.end != 0 ? String(section.end) : ""
            } else if row == 3 {
                return section.classroom
            }
        }
        
        return ""
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + course.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CourseEditTextTableViewCell()
        cell.updateValues(labelText: getLabelTextForCell(at: indexPath), textFieldText: getTextFieldTextForCell(at: indexPath), validIntegers: getValidIntegersForCell(at: indexPath))
        return cell
    }
    
    // MARK: - Table view delegate
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = ToDoHeaderView()
//
//        var sectionName = ""
//        if section == 0 {
//            sectionName = "Course"
//        } else {
//            sectionName = "Section"
//        }
//        headerView.updateValues(sectionName: sectionName)
//
//        return headerView
//    }
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
    
    func getTextFieldText(at indexPath: IndexPath) -> String {
        return getCell(at: indexPath).textField.text!
    }
}

protocol CourseEditViewControllerDelegate {
    func editCourse(_ course: Course, at courseIndex: Int?)
}
