//
//  AssignmentDetailTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/8.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentDetailTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

    var assignment: Assignment?
    
    var indexPathForCourseNameLabel = IndexPath(row: 0, section: 0)
    var indexPathForCourseNamePicker = IndexPath(row: 1, section: 0)
    
    var indexPathForDueDateLabel = IndexPath(row: 0, section: 2)
    var indexPathForDueDatePicker = IndexPath(row: 1, section: 2)
        
    var courses: [String]?
    
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var courseNamePickerView: UIPickerView!
    
    @IBOutlet var contentTextView: UITextView!
    
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    @IBOutlet var isFinishedButton: UIButton!
    @IBOutlet var notFinishedButton: UIButton!
    @IBOutlet var isFinishedLabel: UILabel!
    @IBOutlet var notFinishedLabel: UILabel!
    var status: Bool?
    
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timeTable = Class_.loadTimeTable() ?? Class_.timeTableOfSophomoreSecondSemester
        courses = timeTable.courses
        courses!.insert("Unselected", at: 0)
        
        courseNamePickerView.dataSource = self
        courseNamePickerView.delegate = self
        
        contentTextView.delegate = self
        
        updateView()
        
        if let assignment = assignment {
            courseNameLabel.text = assignment.courseName
            courseNamePickerView.selectRow(courses!.firstIndex(of: assignment.courseName)!, inComponent: 0, animated: true)
            contentTextView.text = assignment.content
            dueDateLabel.text = assignment.dueDate.shortStyleString
            dueDatePicker.date = assignment.dueDate
            if assignment.status {
                isFinishedButton.setTitle( "🟢", for: .normal)
                    isFinishedLabel.textColor = .green
                status = true
                
            } else {
                notFinishedButton.setTitle("🟡", for: .normal)
                notFinishedLabel.textColor = .yellow
                status = false
            }
            saveBarButtonItem.isEnabled = true
        } else {
            deleteButton.isHidden = true
        }
        
        
                        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func tryEnableSaveButton() {
        if courseNameLabel.text != "Unselected", !contentTextView.text.isEmpty, status != nil {
            saveBarButtonItem.isEnabled = true
        } else {
            saveBarButtonItem.isEnabled = false
        }
    }
    
    func updateView() {
        //tableView.backgroundColor = .black
        
        //navigationController?.navigationBar.barStyle = .black
        navigationItem.title = ""
        
        
        
        //courseNameLabel.textColor = .white
        courseNameLabel.textAlignment = .center
        courseNameLabel.text = courses![0]
        
        //courseNamePickerView.backgroundColor = .black
        courseNamePickerView.isHidden = true
        
        //contentTextView.backgroundColor = .black
        //contentTextView.textColor = .white
        contentTextView.text = ""
        
        //dueDatePicker.setValue(UIColor.white, forKey: "textColor")
        dueDatePicker.locale = Locale(identifier: "en_GB")
        dueDatePicker.isHidden = true
        dueDatePicker.date = Date()
        dueDatePicker.minimumDate = Date()
        
        //dueDateLabel.textColor = .white
        dueDateLabel.textAlignment = .center
        dueDateLabel.text = dueDatePicker.date.shortStyleString
        
        isFinishedButton.setTitle("⚫️", for: .normal)
        notFinishedButton.setTitle("⚫️", for: .normal)
        
        //isFinishedLabel.textColor = .white
        isFinishedLabel.textAlignment = .center
        isFinishedLabel.text = "Finished"
        isFinishedLabel.font = UIFont.systemFont(ofSize: 13)
        
        //notFinishedLabel.textColor = .white
        notFinishedLabel.textAlignment = .center
        notFinishedLabel.text = "Not Finished"
        notFinishedLabel.font = UIFont.systemFont(ofSize: 13)
        
        deleteButton.setTitle("DELETE", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        
        saveBarButtonItem.isEnabled = false
    }
    
    @IBAction func dueDatePickerValueChanged(_ sender: UIDatePicker) {
        dueDateLabel.text = dueDatePicker.date.shortStyleString
        
        tryEnableSaveButton()
    }
    
    @IBAction func statusButtonTapped(_ sender: UIButton) {
        if sender == isFinishedButton {
            isFinishedButton.setTitle( "🟢", for: .normal)
            isFinishedLabel.textColor = .green
            status = true
            
            notFinishedButton.setTitle("⚫️", for: .normal)
            notFinishedLabel.textColor = .white
        } else if sender == notFinishedButton {
            notFinishedButton.setTitle("🟡", for: .normal)
            notFinishedLabel.textColor = .yellow
            status = false
            
            isFinishedButton.setTitle("⚫️", for: .normal)
            isFinishedLabel.textColor = .white
        }
        
        tryEnableSaveButton()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "delete the assignment", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.performSegue(withIdentifier: "deleteUnwindSegue", sender: sender)
        }
        alertController.addAction(deleteAction)
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Text View delegate
    func textViewDidChange(_ textView: UITextView) {
        tryEnableSaveButton()
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses!.count
    }
    
    // MARK: - Picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel!.font = UIFont.systemFont(ofSize: 16)
        }
        pickerLabel!.adjustsFontSizeToFitWidth = true
        pickerLabel!.text = courses![row]
        pickerLabel?.textAlignment = .center
//        pickerLabel?.textColor = .white
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        courseNameLabel.text = courses![row]
        
        tryEnableSaveButton()
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveUnwindSegue" {
            assignment = Assignment(content: contentTextView.text!, courseName: courseNameLabel.text!, dueDate: dueDatePicker.date, status: status!)
        }
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == indexPathForCourseNameLabel {
            courseNamePickerView.isHidden = !courseNamePickerView.isHidden
            
            tableView.beginUpdates()
            tableView.endUpdates()
        } else if indexPath == indexPathForDueDateLabel {
            dueDatePicker.isHidden = !dueDatePicker.isHidden
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == indexPathForCourseNamePicker {
            return courseNamePickerView.isHidden ? 0 : 158
        } else if indexPath == indexPathForDueDatePicker {
            return dueDatePicker.isHidden ? 0 : 216
        } else {
            switch indexPath {
            case IndexPath(row: 0, section: 1):
                return 100
            case IndexPath(row: 0, section: 3):
                return 50
            default:
                return 44
            }
        }
    }
}
