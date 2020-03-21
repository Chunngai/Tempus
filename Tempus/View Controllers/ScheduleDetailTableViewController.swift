//
//  ScheduleDetailTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/21.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ScheduleDetailTableViewController: UITableViewController, UITextViewDelegate {

    // Data.
    var task: Task?
    
    // Views.
    var timeButtonStackView: UIStackView!
    var startButton: UIButton!
    var durationButton: UIButton!
    var endButton: UIButton!
    var timeButtons: [UIButton]!
    
//    var timePickerStackView: UIStackView!
    var startPicker: UIDatePicker!
    var durationPicker: UIDatePicker!
    var endPicker: UIDatePicker!
    var timePickers: [UIDatePicker]!
        
    var contentLabel: UILabel!
    var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
            
        updateViews()
    }
    
    func updateViews() {
        // Table view.
        tableView.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        tableView.separatorStyle = .none
        
        // Title of navigation item.
        navigationItem.title = "Detail"
        
        // Time button stack view.
        startButton = UIButton()
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.contentHorizontalAlignment = .center
        
        durationButton = UIButton()
        durationButton.addTarget(self, action: #selector(durationButtonTapped), for: .touchUpInside)
        durationButton.setTitle("Duration", for: .normal)
        durationButton.setTitleColor(.lightText, for: .normal)
        durationButton.contentHorizontalAlignment = .center
                
        endButton = UIButton()
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
        endButton.setTitle("End", for: .normal)
        endButton.setTitleColor(.lightText, for: .normal)
        endButton.contentHorizontalAlignment = .center
        
        timeButtons = [startButton, durationButton, endButton]
        
        timeButtonStackView = UIStackView(arrangedSubviews: [startButton, durationButton, endButton])
        view.addSubview(timeButtonStackView)
        
        timeButtonStackView.axis = .horizontal
        timeButtonStackView.alignment = .fill
        timeButtonStackView.distribution = .fillEqually
        
        timeButtonStackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(view.frame.height / 8)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }
        
        // Time Picker view.
        startPicker = UIDatePicker()
        view.addSubview(startPicker)
        
        startPicker.datePickerMode = .time
        
        startPicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(timeButtonStackView).offset(60)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }
        
        durationPicker = UIDatePicker()
        view.addSubview(durationPicker)
        
        durationPicker.datePickerMode = .countDownTimer
        durationPicker.isHidden = true
        
        durationPicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(timeButtonStackView).offset(60)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }
        
        endPicker = UIDatePicker()
        view.addSubview(endPicker)
        
        endPicker.datePickerMode = .time
        endPicker.isHidden = true
        
        endPicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(timeButtonStackView).offset(60)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }
        
        timePickers = [startPicker, durationPicker, endPicker]
        
        // Content.
        contentLabel = UILabel()
        view.addSubview(contentLabel)
        
        contentLabel.textColor = .white
        contentLabel.text = "Content"
        contentLabel.textAlignment = .center
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(timeButtonStackView).offset(300)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }
        
        contentTextView = UITextView()
        view.addSubview(contentTextView)
        
        contentTextView.delegate = self
        
        contentTextView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        contentTextView.text = "Input task content"
        contentTextView.textColor = .lightText
        contentTextView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                
        contentTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.07)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.86)
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        }
    }
    
    @objc func startButtonTapped() {
        timePickers[0].isHidden.toggle()
        updateTimeViews(buttonIdx: 0)
    }
    
    @objc func durationButtonTapped() {
        timePickers[1].isHidden.toggle()
        updateTimeViews(buttonIdx: 1)
    }
    
    @objc func endButtonTapped() {
        timePickers[2].isHidden.toggle()
        updateTimeViews(buttonIdx: 2)
    }
    
    func updateTimeViews(buttonIdx: Int) {
        for i in 0..<3 {
            if i != buttonIdx {
                timePickers[i].isHidden = true
                timeButtons[i].setTitleColor(.lightText, for: .normal)
            }
        }
        
        timeButtons[buttonIdx].setTitleColor(timePickers[buttonIdx].isHidden ? .lightText : .white, for: .normal)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
