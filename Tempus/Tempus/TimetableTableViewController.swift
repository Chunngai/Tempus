//
//  TimeTableTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/6.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class TimetableTableViewController: UITableViewController {
    
    var timetable: [Class_]?
    var classDict: [Int: Int]?
//    var classNumberOfEachDay: [Int: Int] {
//        var classNumberOfEachDay_: [Int: Int] = [0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0]
//        
//        for class_ in self.timetable! {
////            if classNumberOfEachDay_[class_.day.rawValue] != nil {
////                classNumberOfEachDay_[class_.day.rawValue]! += 1
////            } else {
//            classNumberOfEachDay_[class_.day]! += 1
////            }
//        }
//        
//        return classNumberOfEachDay_
//    }
    
    @IBOutlet var addBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.register(TimetableClassTableViewCell.self, forCellReuseIdentifier: "TimetableClass")
        
        if let timeTable = Class_.loadTimeTable() {
            self.timetable = timeTable
        } else {
            self.timetable = Class_.timeTableOfSophomoreSecondSemester
        }
        
        classDict = timetable?.classDict
        
        timetable?.sortInIncreasingOrderByDayAndSection()
                
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        //tableView.backgroundColor = .black

        navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationBar.barStyle = .black
        
        navigationController?.tabBarItem.title = "Courses"
        navigationItem.title = "Timetable"
        
        //tabBarController?.tabBar.barStyle = .black
    }
    
    func getClassIndex(indexPath: IndexPath) -> Int {
        var index = 0
        for i in 0..<timetable!.count {
            if timetable![i].day < indexPath.section {
                index += 1
            }
        }
        index += indexPath.row
        
        return index
    }
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        return classNumberOfEachDay.count
        return classDict!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowNumber = classDict![section] {
            return rowNumber
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableClass", for: indexPath) as! TimetableClassTableViewCell

        let classIndex = getClassIndex(indexPath: indexPath)
        let class_ = timetable![classIndex]
        
        cell.update(class_: class_)
        
        return cell
    }

//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let classIndex = getClassIndex(indexPath: indexPath)
//            timetable!.remove(at: classIndex)
//            
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TimetableEditSegue",
            let navController = segue.destination as? UINavigationController,
            let timeTableDetailTableViewController = navController.topViewController as? TimetableDetailTableViewController {
            
            let classIndex = getClassIndex(indexPath: tableView.indexPathForSelectedRow!)
            let class_ = timetable![classIndex]
            timeTableDetailTableViewController.class_ = class_
        }
    }
    
    @IBAction func unwindToTimetable(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! TimetableDetailTableViewController
        
        if segue.identifier == "saveUnwindSegue" {
            let class_ = sourceViewController.class_!
                
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                let classIndex = getClassIndex(indexPath: indexPathForSelectedRow)
                
                timetable![classIndex] = class_
                timetable!.sortInIncreasingOrderByDayAndSection()
                
                tableView.reloadData()
            } else {
                timetable!.append(class_)
                timetable!.sortInIncreasingOrderByDayAndSection()
                
                tableView.reloadData()
            }
        } else if segue.identifier == "deleteUnwindSegue" {
            let indexPathForSelectedRow = tableView.indexPathForSelectedRow!
            
            let classIndex = getClassIndex(indexPath: indexPathForSelectedRow)
            timetable!.remove(at: classIndex)
            
            tableView.deleteRows(at: [indexPathForSelectedRow], with: .automatic)
        }
    }

    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if classDict![section] != 0 {
            return Calendar(identifier: .gregorian).shortWeekdaySymbols[section]
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        
        //headerView.textLabel?.textColor = .white
    }
            
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(1)
//        let indexPathForSelectedRow = tableView.indexPathForSelectedRow!
//        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
//    }
    
}

extension Array where Element == Class_ {
    mutating func sortInIncreasingOrderByDayAndSection() {
        self.sort(by: { (classA, classB) -> Bool in
            if classA.day != classB.day {
                return classA.day < classB.day
            } else {
                return classA.sections.from < classB.sections.from
            }
        })
    }
}
