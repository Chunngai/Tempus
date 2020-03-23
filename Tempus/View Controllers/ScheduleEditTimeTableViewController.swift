//
//  ScheduleDetailTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/21.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ScheduleEditTimeTableViewController: UITableViewController {

    // Data.
    var task: Task?
    
    var scheduleViewController: ScheduleViewController!
    
    var initStart: Date!
    var initEnd: Date!
    var initDuration: TimeInterval!
    
    var idx: Int!
    
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
    
        
//    var contentLabel: UILabel!
//    var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
            
//        NotificationCenter.default.addObserver(self, selector: #selector(kbFrameChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        updateInitialViews()
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
    
    @objc func cancelButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonTapped() {
        task?.dateInterval = DateInterval(start: startPicker.date.GTM8(), end: endPicker.date.GTM8())
        
        let scheduleEditContentTableViewController = ScheduleEditContentTableViewController()
        scheduleEditContentTableViewController.task = task
        scheduleEditContentTableViewController.scheduleViewController = self.scheduleViewController
        scheduleEditContentTableViewController.idx = idx
        navigationController?.pushViewController(scheduleEditContentTableViewController, animated: true)
    }
    
    func updateInitialViews() {
        // Table view.
        tableView.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        tableView.separatorStyle = .none
        
        // Title of navigation item.
        navigationItem.title = "Time"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Content", style: .done, target: self, action: #selector(nextButtonTapped))
        
        // Time button stack view.
        startButton = UIButton()
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.setTitleColor(.white, for: .normal)
        startButton.contentHorizontalAlignment = .center
        if let initStart = initStart {
            startButton.setTitle(initStart.formattedTime(), for: .normal)
        } else {
            startButton.setTitle(Date(hour: 8, minute: 30).GTM8().formattedTime(), for: .normal)
        }
        
        durationButton = UIButton()
        durationButton.addTarget(self, action: #selector(durationButtonTapped), for: .touchUpInside)
        durationButton.setTitleColor(.lightText, for: .normal)
        durationButton.contentHorizontalAlignment = .center
        if let initDuration = initDuration {
            durationButton.setTitle(String(initDuration.formattedDuration()), for: .normal)
        } else {
            durationButton.setTitle("0h 30m", for: .normal)
        }
                
        endButton = UIButton()
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
        endButton.setTitleColor(.lightText, for: .normal)
        endButton.contentHorizontalAlignment = .center
        if let initEnd = initEnd {
            endButton.setTitle(initEnd.formattedTime(), for: .normal)
        } else {
            endButton.setTitle(Date(hour: 9, minute: 0).GTM8().formattedTime(), for: .normal)
        }
        
        timeButtons = [startButton, durationButton, endButton]
        
        timeButtonStackView = UIStackView(arrangedSubviews: [startButton, durationButton, endButton])
        view.addSubview(timeButtonStackView)
        
        timeButtonStackView.axis = .horizontal
        timeButtonStackView.alignment = .fill
        timeButtonStackView.distribution = .fillEqually
        
        timeButtonStackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(view.frame.height / 5)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }
        
        // Time Picker view.
        startPicker = UIDatePicker(frame: CGRect(x: UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.height * 0.25, width: UIScreen.main.bounds.width * 0.50, height: 200))
        view.addSubview(startPicker)
        
        startPicker.addTarget(self, action: #selector(startPickerValueChanged), for: .valueChanged)
        
        startPicker.datePickerMode = .time
        if let initStart = initStart {
            startPicker.setDate(Date(timeInterval: -8 * 3600, since: initStart), animated: true)
        } else {
            startPicker.setDate(Date(hour: 8, minute: 30), animated: true)
        }
        
//        startPicker.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.30)
//            make.top.equalTo(timeButtonStackView).offset(60)
//            make.width.equalTo(UIScreen.main.bounds.width * 0.40)
//        }
        
        durationPicker = UIDatePicker(frame: CGRect(x: UIScreen.main.bounds.width * 0.20, y: UIScreen.main.bounds.height * 0.25, width: UIScreen.main.bounds.width * 0.60, height: 200))
        view.addSubview(durationPicker)
        
        durationPicker.addTarget(self, action: #selector(durationPickerValueChanged), for: .valueChanged)
        
        durationPicker.datePickerMode = .countDownTimer
        durationPicker.isHidden = true
        durationPicker.minuteInterval = 5
        if let initDuration = initDuration {
            durationPicker.setValue(initDuration, forKeyPath: "countDownDuration")
        } else {
            durationPicker.setValue(1800, forKeyPath: "countDownDuration")
        }
        
//        durationPicker.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.25)
//            make.top.equalTo(timeButtonStackView).offset(60)
//            make.width.equalTo(UIScreen.main.bounds.width * 0.50)
//        }
        
        endPicker = UIDatePicker(frame: CGRect(x: UIScreen.main.bounds.width * 0.20, y: UIScreen.main.bounds.height * 0.25, width: UIScreen.main.bounds.width * 0.60, height: 200))
        view.addSubview(endPicker)
        
        endPicker.addTarget(self, action: #selector(endPickerValueChanged), for: .valueChanged)
        
        endPicker.datePickerMode = .time
        endPicker.isHidden = true
        if let initEnd = initEnd {
            endPicker.setDate(Date(timeInterval: -8 * 3600, since: initEnd), animated: true)
        } else {
            endPicker.setDate(Date(hour: 9, minute: 0), animated: true)
        }
        
//        endPicker.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.25)
//            make.top.equalTo(timeButtonStackView).offset(60)
//            make.width.equalTo(UIScreen.main.bounds.width * 0.50)
//        }
        
        timePickers = [startPicker, durationPicker, endPicker]
        
        
        
        
        // Content.
//        contentLabel = UILabel()
//        view.addSubview(contentLabel)
//
//        contentLabel.textColor = .white
//        contentLabel.text = "Content"
//        contentLabel.textAlignment = .center
//
//        contentLabel.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
//            make.top.equalTo(timeButtonStackView).offset(300)
//            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
//        }
//
//        contentTextView = UITextView()
//        view.addSubview(contentTextView)
//
//        contentTextView.delegate = self
//
//        contentTextView.backgroundColor = UIColor.sky.withAlphaComponent(0)
//        contentTextView.text = "Input task content"
//        contentTextView.textColor = .lightText
//        contentTextView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//        contentTextView.inputAccessoryView = addDoneButton()
//
//        contentTextView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.07)
//            make.top.equalTo(contentLabel.snp.bottom).offset(20)
//            make.width.equalTo(UIScreen.main.bounds.width * 0.86)
//            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
//        }
    }
    
        
//    func addDoneButton() -> UIToolbar{
//        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentTextView.frame.width, height: 20))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let barButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishEditing))
//
//        toolBar.items = [spaceButton, barButton]
//        toolBar.sizeToFit()
//
//        return toolBar
//    }
    
    @objc func startPickerValueChanged() {
        startButton.setTitle(startPicker.date.GTM8().formattedTime(), for: .normal)
        
        endPicker.setDate(Date(timeInterval: durationPicker.countDownDuration, since: startPicker.date), animated: true)
        endButton.setTitle(endPicker.date.GTM8().formattedTime(), for: .normal)
    }

    @objc func durationPickerValueChanged() {
        durationButton.setTitle(durationPicker.countDownDuration.formattedDuration(), for: .normal)
        
        endPicker.setDate(Date(timeInterval: durationPicker.countDownDuration, since: startPicker.date), animated: true)
        endButton.setTitle(endPicker.date.GTM8().formattedTime(), for: .normal)
    }
    
    @objc func endPickerValueChanged() {
        endButton.setTitle(endPicker.date.GTM8().formattedTime(), for: .normal)
        
        durationPicker.setValue(DateInterval(start: startPicker.date, end: endPicker.date).duration, forKeyPath: "countDownDuration")
        durationButton.setTitle(durationPicker.countDownDuration.formattedDuration(), for: .normal)
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
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.text = ""
//        textView.textColor = .white
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text!.isEmpty {
//            contentTextView.text = "Input task content"
//            contentTextView.textColor = .lightText
//        }
//    }
//
//    @objc func finishEditing() {
//        view.endEditing(false)
//    }

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
