//
//  ScheduleEditViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/24.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ScheduleEditViewController: UIViewController, UITextViewDelegate {

    // Data.
    var task: Task!

    var scheduleViewController: ScheduleViewController!

    var initStart: Date!
    var initEnd: Date!
    var initDuration: TimeInterval!

    var indexCountedFromOne: Int?

    // Views.
    var gradientLayer = CAGradientLayer()
    
    var contentLabel: UILabel!

    var contentTextView: UITextView!

    var timeLabel: UILabel!

    var startButton: UIButton!
    var durationButton: UIButton!
    var endButton: UIButton!
    var timeButtonStackView: UIStackView!
    var timeButtons: [UIButton]!

    var startPicker: UIDatePicker!
    var durationPicker: UIDatePicker!
    var endPicker: UIDatePicker!
    var timePickers: [UIDatePicker]!

    var deleteButton: UIButton!
      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateInitialViews()
    }

    func updateInitialViews() {
        // Table view.
        view.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        
        view.addGradientLayer(gradientLayer: gradientLayer,
            colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
            locations: [0.0, 1.0],
            startPoint: CGPoint(x: 0, y: 1),
            endPoint: CGPoint(x: 1, y: 0.5),
            frame: self.view.bounds)
        
        // Title of navigation item.
        navigationItem.title = "Detail"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
        // Content.
        contentLabel = UILabel()
        view.addSubview(contentLabel)

        contentLabel.textColor = .white
        contentLabel.text = "Content"
        contentLabel.textAlignment = .center
        
        // TODO: rm the content label?
        contentLabel.isHidden = true

        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 8)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }

        // Content text view.
        contentTextView = UITextView()
        view.addSubview(contentTextView)

        contentTextView.delegate = self

        contentTextView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        contentTextView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        contentTextView.inputAccessoryView = addDoneButton()
        contentTextView.textColor = .white
        if let content = task.content {
            contentTextView.text = content
//            contentTextView.textColor = .white
        } else {
            contentTextView.text = ""
//            contentTextView.textColor = .lightText
        }

        contentTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.10)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.90)
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        }
        
        // Time label.
        timeLabel = UILabel()
        view.addSubview(timeLabel)

        timeLabel.textColor = .white
        timeLabel.text = "Time"
        timeLabel.textAlignment = .center
        
        // rm the time label?
        timeLabel.isHidden = true

        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(contentTextView).offset(180)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }
        
        // Time button views.
        startButton = UIButton()
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        startButton.setTitleColor(.white, for: .normal)
        startButton.contentHorizontalAlignment = .left
        startButton.setTitle(initStart.formattedTime(), for: .normal)
        
        durationButton = UIButton()
        
        durationButton.addTarget(self, action: #selector(durationButtonTapped), for: .touchUpInside)
        
        durationButton.setTitleColor(.lightText, for: .normal)
        durationButton.contentHorizontalAlignment = .left
        durationButton.setTitle(String(initDuration.formattedDuration()), for: .normal)
               
        endButton = UIButton()
        
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
        
        endButton.setTitleColor(.lightText, for: .normal)
        endButton.contentHorizontalAlignment = .left
        endButton.setTitle(initEnd.formattedTime(), for: .normal)
        
        // Time button stack view.
        timeButtons = [startButton, durationButton, endButton]
        
        timeButtonStackView = UIStackView(arrangedSubviews: timeButtons)
        view.addSubview(timeButtonStackView)
        
        timeButtonStackView.axis = .vertical
        timeButtonStackView.alignment = .fill
        timeButtonStackView.distribution = .fillEqually
        
        timeButtonStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.12)
            make.top.equalTo(timeLabel).offset(30)
            make.width.equalTo(UIScreen.main.bounds.width * 0.30)
            make.height.equalTo(UIScreen.main.bounds.height * 0.28)
        }
        
        // Time Picker views.
        // TODO: modify the y pos
        startPicker = UIDatePicker(frame: CGRect(x: UIScreen.main.bounds.width * 0.30, y: 350, width: UIScreen.main.bounds.width * 0.60, height: UIScreen.main.bounds.height * 0.28))
        view.addSubview(startPicker)
        
        startPicker.addTarget(self, action: #selector(startPickerValueChanged), for: .valueChanged)
        
        startPicker.setValue(UIColor.white, forKeyPath: "textColor")
        startPicker.datePickerMode = .time
        startPicker.setDate(Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: initStart), animated: true)
        
        durationPicker = UIDatePicker(frame: CGRect(x: UIScreen.main.bounds.width * 0.30, y: 350, width: UIScreen.main.bounds.width * 0.60, height: UIScreen.main.bounds.height * 0.28))
        view.addSubview(durationPicker)
        
        durationPicker.addTarget(self, action: #selector(durationPickerValueChanged), for: .valueChanged)
        
        durationPicker.setValue(UIColor.white, forKeyPath: "textColor")
        durationPicker.datePickerMode = .countDownTimer
        durationPicker.isHidden = true
        durationPicker.minuteInterval = 5
        durationPicker.setValue(initDuration, forKeyPath: "countDownDuration")
        
        endPicker = UIDatePicker(frame: CGRect(x: UIScreen.main.bounds.width * 0.30, y: 350, width: UIScreen.main.bounds.width * 0.60, height: UIScreen.main.bounds.height * 0.28))
        view.addSubview(endPicker)
        
        endPicker.addTarget(self, action: #selector(endPickerValueChanged), for: .valueChanged)
        
        endPicker.setValue(UIColor.white, forKeyPath: "textColor")
        endPicker.datePickerMode = .time
        endPicker.isHidden = true
        endPicker.setDate(Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: initEnd), animated: true)
        
        timePickers = [startPicker, durationPicker, endPicker]
        
        // Delete Button.
        deleteButton = UIButton()
        if indexCountedFromOne != nil {
            view.addSubview(deleteButton)
            
            deleteButton.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.30)
                make.top.equalTo(timeButtonStackView).offset(320)
            }
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor.red.withAlphaComponent(0.5), for: .normal)
        
        // Disables editing if the task is set before the current day.
        if !scheduleViewController.editable {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
            
            contentTextView.isEditable = false
            
            startButton.isEnabled = false
            durationButton.setTitleColor(.white, for: .normal)
            durationButton.isEnabled = false
            endButton.setTitleColor(.white, for: .normal)
            endButton.isEnabled = false
            
            startPicker.isEnabled = false;
            durationPicker.isEnabled = false
            endPicker.isEnabled = false
            
            deleteButton.isHidden = true
        }
    }
    
    func updateValues(scheduleViewController: ScheduleViewController, task: Task, initStart: Date, initDuration: TimeInterval, initEnd: Date, indexCountedFromOne: Int?) {
        self.scheduleViewController = scheduleViewController
        self.task = task
        self.initStart = initStart
        self.initDuration = initDuration
        self.initEnd = initEnd
        self.indexCountedFromOne = indexCountedFromOne
    }
    
    @objc func cancelButtonTapped() {
//        scheduleViewController.navigationController?.popViewController(animated: true)
        scheduleViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        scheduleViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func emptyContentAlert() {
        let alertController = UIAlertController(title: "Error", message: "Content cannot be empty", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        if contentTextView.text.trimmingCharacters(in: CharacterSet(charactersIn: " ")).isEmpty {
            emptyContentAlert()
            return
        }
        
        task.dateInterval = Interval(start: startPicker.date.dateOfCurrentTimeZone(), end: endPicker.date.dateOfCurrentTimeZone())
        self.task.content = contentTextView.text
        self.task.isFinished = task.isFinished ?? false
        
        self.scheduleViewController.editTask(task: self.task, indexCountedFromOne: self.indexCountedFromOne)
        
//        scheduleViewController.navigationController?.popViewController(animated: true)
        scheduleViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "Input task content" {
//           textView.text = ""
//        }
//        textView.textColor = .white
    }

    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text!.isEmpty {
//            contentTextView.text = "Input task content"
//            contentTextView.textColor = .lightText
//        }
    }

    @objc func finishEditing() {
        view.endEditing(false)
    }
    
    func addDoneButton() -> UIToolbar{
           let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentTextView.frame.width, height: 20))
           
           toolBar.tintColor = .sky
           
           let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let barButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishEditing))

           toolBar.items = [spaceButton, barButton]
           toolBar.sizeToFit()

           return toolBar
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
    
    @objc func startPickerValueChanged() {
        startButton.setTitle(startPicker.date.dateOfCurrentTimeZone().formattedTime(), for: .normal)
        
        endPicker.setDate(Date(timeInterval: durationPicker.countDownDuration, since: startPicker.date), animated: true)
        endButton.setTitle(endPicker.date.dateOfCurrentTimeZone().formattedTime(), for: .normal)
    }

    @objc func durationPickerValueChanged() {
        durationButton.setTitle(durationPicker.countDownDuration.formattedDuration(), for: .normal)
        
        endPicker.setDate(Date(timeInterval: durationPicker.countDownDuration, since: startPicker.date), animated: true)
        endButton.setTitle(endPicker.date.dateOfCurrentTimeZone().formattedTime(), for: .normal)
    }
    
    @objc func endPickerValueChanged() {
        endButton.setTitle(endPicker.date.dateOfCurrentTimeZone().formattedTime(), for: .normal)
        
        if startPicker.date < endPicker.date {
            durationPicker.setValue(DateInterval(start: startPicker.date, end: endPicker.date).duration, forKeyPath: "countDownDuration")
            durationButton.setTitle(durationPicker.countDownDuration.formattedDuration(), for: .normal)
        } else {
            startPicker.setDate(endPicker.date - durationPicker.countDownDuration, animated: true)
            startButton.setTitle(startPicker.date.dateOfCurrentTimeZone().formattedTime(), for: .normal)
        }
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

    @objc func deleteButtonTapped() {
        self.scheduleViewController.editTask(task: self.task, indexCountedFromOne: indexCountedFromOne! * -1)

//        scheduleViewController.navigationController?.popViewController(animated: true)
        scheduleViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}

protocol TaskEditingDelegate {
    func editTask(task: Task, indexCountedFromOne: Int?)
}
