//
//  ScheduleEditContentTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/21.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ScheduleEditContentTableViewController: UITableViewController, UITextViewDelegate {

    // Data.
    var task: Task!
    
    var scheduleViewController: ScheduleViewController!
    
    // Views.
    var contentLabel: UILabel!
    var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        NotificationCenter.default.addObserver(self, selector: #selector(kbFrameChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        updateViews()
    }
    
    func updateViews() {
        // Table view.
        tableView.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        tableView.separatorStyle = .none
        
        // Title of navigation item.
        navigationItem.title = "Content"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Time", style: .plain, target: self, action: #selector(timeButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
        // Content.
        contentLabel = UILabel()
        view.addSubview(contentLabel)

        contentLabel.textColor = .white
        contentLabel.text = "Content"
        contentLabel.textAlignment = .center

        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 5)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }

        contentTextView = UITextView()
        view.addSubview(contentTextView)

        contentTextView.delegate = self

        contentTextView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        contentTextView.text = "Input task content"
        contentTextView.textColor = .lightText
        contentTextView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        contentTextView.inputAccessoryView = addDoneButton()

        contentTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.07)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.86)
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        }
    }
    
//    @objc func kbFrameChanged(_ notification: Notification) {
//        let info = notification.userInfo
//
//        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
//        UIView.animate(withDuration: 0.3) {
//            self.view.transform = CGAffineTransform(translationX: 0, y: offsetY)
//        }
//    }
            
    func addDoneButton() -> UIToolbar{
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentTextView.frame.width, height: 20))
        
        toolBar.tintColor = .sky
//        toolBar.barTintColor = UIColor.sky.withAlphaComponent(0.1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishEditing))

        toolBar.items = [spaceButton, barButton]
        toolBar.sizeToFit()

        return toolBar
    }

    
    @objc func timeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonTapped() {
        self.task.content = contentTextView.text
        self.task.isFinished = false
        
        dismiss(animated: true) {
            self.scheduleViewController.finishedEditing(task: self.task)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .white
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text!.isEmpty {
            contentTextView.text = "Input task content"
            contentTextView.textColor = .lightText
        }
    }

    @objc func finishEditing() {
        view.endEditing(false)
    }

//    // MARK: - Table view data source
//
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol ScheduleEditDelegate {
    func finishedEditing(task: Task)
}
