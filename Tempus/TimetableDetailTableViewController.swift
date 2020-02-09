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
    
    
    @IBOutlet var courseNameTextField: UITextField!
    
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
    
    @IBOutlet var classroomTextField: UITextField!
    
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.backgroundColor = .black
        
        //navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [:]
        
        navigationItem.title = ""
        //navigationController?.navigationBar.titleTextAttributes![NSAttributedString.Key.foregroundColor] = UIColor.white
        
        updateCourseNameSection()
        updateDaySection()
        updateTimeSection()
        updateClassroomSection()
        updateDeleteButton()
        updateBarButtonItem()
        updateEditInfo()
        
        if class_ == nil {
            deleteButton.isHidden = true
        }
    }
    
    func updateEditInfo() {
        if let class_ = class_ {
            courseNameTextField.text = class_.courseName
            dayButtons[class_.day].setTitleColor(.systemPink, for: .normal)
            timeLabel.text = class_.timeString
            (sectionFromTextField.text, sectionToTextField.text) = (String(class_.sections.from), String(class_.sections.to))
            classroomTextField.text = class_.classroom
        }
    }
    
    
    @IBAction func courseNameTextFieldEditingChanged(_ sender: UITextField) {
        tryEnableSaveBarButtonItem()
    }
    
    func updateCourseNameSection() {
        //courseNameTextField.backgroundColor = .black
        //courseNameTextField.textColor = .white
    }
    
    @IBAction func dayButtonTapped(_ sender: UIButton) {
        for button in dayButtons {
            if button.titleColor(for: .normal) == .lightGray {
                button.setTitleColor(.black, for: .normal)
            }
        }
        
        day = dayButtons.firstIndex(of: sender)
        
        sender.setTitleColor(.lightGray, for: .normal)
        tryEnableSaveBarButtonItem()
    }
    
    func updateDaySection() {
        dayStackView.distribution = .fillEqually
        
        for buttonIndex in 0..<dayButtons.count {
            dayButtons[buttonIndex].setTitleColor(.systemTeal, for: .normal)
            dayButtons[buttonIndex].setTitle(Calendar(identifier: .gregorian).shortWeekdaySymbols[buttonIndex], for: .normal)
        }
    }
    
    @IBAction func sectionTextFieldEditingChanged(_ sender: UITextField) {
        guard !sender.text!.isEmpty, let section = sender.text else { return }
        
        // TODO: - sectionFrom should be less than sectionTo
        // TODO: - use picker view instead
        
        let sectionNum = Int(section)!
        if sender == sectionFromTextField {
            if sectionNum > 0 && sectionNum < 16 {
            } else if sectionNum == 0 {
                sectionFromTextField.text = "1"
            } else if sectionNum >= 16 {
                sectionFromTextField.text = "15"
            }
            
        } else if sender == sectionToTextField {
            if sectionNum > 0 && sectionNum < 16 {
            } else if sectionNum == 0 {
                sectionToTextField.text = "1"
            } else if sectionNum >= 16 {
                sectionToTextField.text = "15"
            }
            
            if let sectionFrom = Int(sectionFromTextField.text!), sectionNum < sectionFrom {
                sectionToTextField.text = String(sectionFrom + 1)
            }
        }
        
        if !sectionFromTextField.text!.isEmpty && !sectionToTextField.text!.isEmpty {
            let start = Class_.section2Time(sectionNum: Int(sectionFromTextField.text!)!).start!
            let finish = Class_.section2Time(sectionNum: Int(sectionToTextField.text!)!).finish!
            timeLabel.text = "\(start.hour!):\(start.minute!) - \(finish.hour!):\(finish.minute!)"
        }
        
        tryEnableSaveBarButtonItem()
    }
    
    func updateTimeSection() {
        timeLabel.text = ""
        timeLabel.textAlignment = .center
        //timeLabel.textColor = .systemTeal
        
        timeVerticalStack.axis = .vertical
        timeVerticalStack.distribution = .fillEqually
        
        sectionFromStack.distribution = .fill
        sectionToStack.distribution = .fill
                
        sectionFromLabel.text = "from section (1 - 14)"
        //sectionFromLabel.textColor = .systemTeal
        sectionToLabel.text = "to     section (2 - 15)"
        //sectionToLabel.textColor = .systemTeal
        
        //sectionFromTextField.backgroundColor = .black
        //sectionFromTextField.textColor = .white
        sectionFromTextField.keyboardType = .numberPad
        //sectionToTextField.backgroundColor = .black
        //sectionToTextField.textColor = .white
        sectionToTextField.keyboardType = .numberPad
    }
        
    @IBAction func classroomTextFieldEditingChanged(_ sender: UITextField) {
        tryEnableSaveBarButtonItem()
    }

    func updateClassroomSection() {
        //classroomTextField.backgroundColor = .black
        //classroomTextField.textColor = .white
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Delete the class", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.performSegue(withIdentifier: "deleteUnwindSegue", sender: sender)
        }
        alertController.addAction(deleteAction)
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func updateDeleteButton() {
        //deleteButton.backgroundColor = .black
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.setTitle("DELETE", for: .normal)
    }
    
//    @IBAction func cancelBarButtonItemTapped(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    
//    @IBAction func saveBarButtonItemTapped(_ sender: UIBarButtonItem) {
//
//    }
    
    func updateBarButtonItem() {
        saveBarButtonItem.isEnabled = false
    }
    
    func tryEnableSaveBarButtonItem() {
        if !courseNameTextField.text!.isEmpty
            && day != nil
            && !sectionFromTextField.text!.isEmpty
            && !sectionToTextField.text!.isEmpty
            && !classroomTextField.text!.isEmpty {
            saveBarButtonItem.isEnabled = true
        } else {
            saveBarButtonItem.isEnabled = false
        }
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

    /*(
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "saveUnwindSegue" {
            class_ = Class_(courseName: courseNameTextField.text!, day: day!, sections: (from: Int(sectionFromTextField.text!)!, to: Int(sectionToTextField.text!)!), classroom: classroomTextField.text!)
        }
    }

    // MARK: - Delegate
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        if section != 3 {
//            return sectionHeaderTitles[section]
//        } else {
//            return ""
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
