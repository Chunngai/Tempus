//
//  TimeTableTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/6.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class TimetableTableViewController: UITableViewController {
    
    var timeTable: [Class_]?
    var classNumberOfEachDay: [Int: Int] {
        var classNumberOfEachDay_: [Int: Int] = [0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0]
        
        for class_ in self.timeTable! {
//            if classNumberOfEachDay_[class_.day.rawValue] != nil {
//                classNumberOfEachDay_[class_.day.rawValue]! += 1
//            } else {
            classNumberOfEachDay_[class_.day]! += 1
//            }
        }
        
        return classNumberOfEachDay_
    }
    
    @IBOutlet var addBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let timeTable = Class_.loadTimeTable() {
            self.timeTable = timeTable
        } else {
            self.timeTable = Class_.timeTableOfSophomoreSecondSemester
        }
        
        timeTable?.sort(by: { (classA, classB) -> Bool in
            if classA.day != classB.day {
                return classA.day < classB.day
            } else {
                return classA.sections.first! < classB.sections.first!
            }
        })
                
        tableView.rowHeight = 80
        tableView.separatorColor = .systemTeal
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
                
        navigationItem.title = "Timetable"
        
        tabBarController?.tabBar.barStyle = .black
    }
    
    func getClassIndex(indexPath: IndexPath) -> Int {
        var index = 0
        for i in 0..<timeTable!.count {
            if timeTable![i].day < indexPath.section {
                index += 1
            }
        }
        index += indexPath.row
        
        return index
    }
    
    @IBAction func addBarButtonItemTapped(_ sender: UIButton) {
        
    }
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        return classNumberOfEachDay.count
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionNum = classNumberOfEachDay[section] ?? 0
        
        return sectionNum
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableClass", for: indexPath) as! TimetableClassTableViewCell

        let classIndex = getClassIndex(indexPath: indexPath)
        let class_ = timeTable![classIndex]
        
        cell.update(class_: class_)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        
    }

    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if classNumberOfEachDay[section] != 0 {
            return Calendar(identifier: .gregorian).shortWeekdaySymbols[section]
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        
        headerView.textLabel?.textColor = .systemTeal
    }
            
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(1)
        let indexPathForSelectedRow = tableView.indexPathForSelectedRow!
        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
    
}
