//
//  TimetableDetailTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/7.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class TimetableDetailTableViewController: UITableViewController {

    var class_: Class_?
    let sectionHeaderTitles = [0: "DAY", 1: "TIME", 2: "CLASSROOM"]
    
    @IBOutlet var dayStackView: UIStackView!
    @IBOutlet var dayButtons: [UIButton]!
    var day: Int?
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeVerticalStack: UIStackView!
    @IBOutlet var sectionFromStack: UIStackView!
    @IBOutlet var sectionToStack: UIStackView!
    @IBOutlet var sectionFromLabel: UILabel!
    @IBOutlet var sectionFromTextField: UITextField!
    @IBOutlet var sectionToLabel: UILabel!
    @IBOutlet var sectionToTextField: UITextField!
    var sectionFrom: Int?
    var sectionTo: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .black
        
        navigationController?.navigationBar.barStyle = .black
        
        updateDaySection()
        updateTimeSection()
    }
    
    @IBAction func dayButtonTapped(_ sender: UIButton) {
        day = dayButtons.firstIndex(of: sender)!
    }
    
    func updateDaySection() {
        dayStackView.distribution = .fillEqually
        
        for buttonIndex in 0..<dayButtons.count {
            dayButtons[buttonIndex].setTitleColor(.systemTeal, for: .normal)
            dayButtons[buttonIndex].setTitle(Calendar(identifier: .gregorian).shortWeekdaySymbols[buttonIndex], for: .normal)
        }
    }
    
    @IBAction func sectionTextFieldEditingDidEnd(_ sender: UITextField) {
        guard !sender.text!.isEmpty, let section = sender.text else { return }
        
        let sectionNum = Int(section)!
        if sender == sectionFromTextField {
            if sectionNum > 0 && sectionNum < 16 {
                sectionFrom = sectionNum
            } else if sectionNum == 0 {
                sectionFromTextField.text = "1"
                sectionFrom = 1
            } else if sectionNum >= 16 {
                sectionFromTextField.text = "15"
                sectionFrom = 15
            }
        } else if sender == sectionToTextField {
            if sectionNum > 0 && sectionNum < 16 {
                sectionTo = sectionNum
            } else if sectionNum == 0 {
                sectionToTextField.text = "1"
                sectionTo = 1
            } else if sectionNum >= 16 {
                sectionToTextField.text = "15"
                sectionTo = 15
            }
        }
        
        if !sectionFromTextField.text!.isEmpty && !sectionToTextField.text!.isEmpty {
            let start = Class_.section2Time(sectionNum: sectionFrom!).start!
            let finish = Class_.section2Time(sectionNum: sectionTo!).finish!
            timeLabel.text = "\(start.hour!):\(start.minute!) - \(finish.hour!):\(finish.minute!)"
        }
    }
    
    func updateTimeSection() {
        timeLabel.text = " "
        timeLabel.textAlignment = .center
        timeLabel.textColor = .systemTeal
        
        timeVerticalStack.axis = .vertical
        timeVerticalStack.distribution = .fillEqually
        
        sectionFromStack.distribution = .fill
        sectionToStack.distribution = .fill
                
        sectionFromLabel.text = "from section (1 - 14)"
        sectionFromLabel.textColor = .systemTeal
        sectionToLabel.text = "to     section (2 - 15)"
        sectionToLabel.textColor = .systemTeal
        
        sectionFromTextField.backgroundColor = .lightGray
        sectionFromTextField.textColor = .white
        sectionFromTextField.keyboardType = .numberPad
        sectionToTextField.backgroundColor = .lightGray
        sectionToTextField.textColor = .white
        sectionToTextField.keyboardType = .numberPad
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section != 1 {
//            return 2
//        } else {
//            return 1
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Delegate
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        if section != 3 {
//            return sectionHeaderTitles[section]
//        } else {
//            return ""
//        }
//    }
}
