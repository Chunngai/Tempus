//
//  ToDoEditViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/29.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ToDoEditViewController: UIViewController, UITextViewDelegate {
    // MARK: - Models
    
    var task: Task!
    
    var oldIdx: (categoryIdx: Int, taskIdx: Int)!
    var currentIdx: Int! {
        didSet {
            categoryButton.setTitle(toDoViewController.toDoList.categories[self.currentIdx], for: .normal)
        }
    }
    
    // MARK: - Controllers
    
    var toDoViewController: ToDoViewController!
        
    var mode: String!
    
    // MARK: - Views
    
    var gradientLayer = CAGradientLayer()
    
    var contentLabel: UILabel!
    var contentTextView: UITextView!
    
    var fromButton = UIButton()
    var toButton = UIButton()
    var dateButtonStackView: UIStackView!
    var dateButtons: [UIView]!
    
    var fromDatePicker: UIDatePicker!
    var toDatePicker: UIDatePicker!
    
    var categoryButton = UIButton()
    
    var deleteButton: UIButton!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateInitialViews()
    }
    
    // MARK: - Customized funcs
    
    func updateInitialViews() {
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

        contentLabel.isHidden = true
        contentLabel.textColor = .white
        contentLabel.text = "Content"
        contentLabel.textAlignment = .center

        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 8)
        }

        // Content text view.
        contentTextView = UITextView()
        view.addSubview(contentTextView)

        contentTextView.delegate = self

        contentTextView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        contentTextView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        contentTextView.textColor = .white
        contentTextView.inputAccessoryView = addDoneButton()
        if let content = task.content {
            contentTextView.text = content
        } else {
            contentTextView.text = ""
        }

        contentTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.10)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.80)
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        }
        
        // Date buttons.
        fromButton.addTarget(self, action: #selector(fromButtonTapped), for: .touchUpInside)
        
        fromButton.setTitleColor(.white, for: .normal)
        fromButton.contentHorizontalAlignment = .center
        if let taskDateIntervalStart = task.dateInterval.start {
            fromButton.setTitle("\(taskDateIntervalStart.formattedDateAndTime())", for: .normal)
        } else {
            fromButton.setTitle("--/-- --:--", for: .normal)
        }
                       
        toButton.addTarget(self, action: #selector(toButtonTapped), for: .touchUpInside)
        
        toButton.setTitleColor(.lightText, for: .normal)
        toButton.contentHorizontalAlignment = .center
        if let taskDateIntervalEnd = task.dateInterval.end {
            toButton.setTitle("\(taskDateIntervalEnd.formattedDateAndTime())", for: .normal)
        } else {
            toButton.setTitle("--/-- --:--", for: .normal)
        }
        
        // Time button stack view.
        dateButtons = [fromButton, toButton]
        
        dateButtonStackView = UIStackView(arrangedSubviews: dateButtons)
        view.addSubview(dateButtonStackView)
        
        dateButtonStackView.axis = .horizontal
        dateButtonStackView.alignment = .center
        dateButtonStackView.distribution = .equalCentering
        dateButtonStackView.spacing = 20
        
        dateButtonStackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.18)
            make.top.equalTo(contentTextView.snp.bottom).offset(25)
        }
        
        // Date Pickers.
        let datePickerFrame = CGRect(x: UIScreen.main.bounds.width * 0.15, y: UIScreen.main.bounds.height * 0.43, width: UIScreen.main.bounds.width * 0.70, height: UIScreen.main.bounds.height * 0.28)
        
        fromDatePicker = UIDatePicker(frame: datePickerFrame)
        view.addSubview(fromDatePicker)
        
        fromDatePicker.addTarget(self, action: #selector(fromPickerValueChanged), for: .valueChanged)
        
        fromDatePicker.minimumDate = Date()
        fromDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        fromDatePicker.isHighlighted = false
        fromDatePicker.datePickerMode = .dateAndTime
        if let taskDateIntervalStart = task.dateInterval.start {
            fromDatePicker.setDate(Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: taskDateIntervalStart), animated: true)
        } else {
            fromDatePicker.setDate(Date(), animated: true)
            fromDatePicker.isHidden = true
        }
        
        toDatePicker = UIDatePicker(frame: datePickerFrame)
        view.addSubview(toDatePicker)
        
        toDatePicker.addTarget(self, action: #selector(toPickerValueChanged), for: .valueChanged)
        
        toDatePicker.minimumDate = Date()
        toDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        toDatePicker.isHighlighted = false
        toDatePicker.datePickerMode = .dateAndTime
        toDatePicker.isHidden = true
        if let taskDateIntervalEnd = task.dateInterval.end {
            toDatePicker.setDate(Date(timeInterval: -TimeInterval.secondsOfCurrentTimeZoneFromGMT, since: taskDateIntervalEnd), animated: true)
        } else {
            toDatePicker.setDate(Date(timeInterval: 3600, since: Date()), animated: true)
            toDatePicker.isHidden = true
        }
        
        // Category button.
        view.addSubview(categoryButton)
        
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        if mode == "a" {
            currentIdx = 0
            categoryButton.setTitle(toDoViewController.toDoList.categories[0], for: .normal)
        } else {
            currentIdx = toDoViewController.toDoList.getCategoryIdx(category: task.category)
            categoryButton.setTitle(task.category, for: .normal)
        }
        categoryButton.setTitleColor(UIColor.blue.withAlphaComponent(0.3), for: .normal)
        
        categoryButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.20)
            make.bottom.equalToSuperview().inset(100)
        }
        
        // Delete Button.
        deleteButton = UIButton()

        if oldIdx != nil {
            view.addSubview(deleteButton)
            
            deleteButton.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.30)
                make.bottom.equalTo(UIScreen.main.bounds.height * 0.06).inset(30)
            }
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor.red.withAlphaComponent(0.5), for: .normal)
    }
    
    func updateValues(task: Task, toDoViewController: ToDoViewController, mode: String, oldIdx: (Int, Int)?) {
        self.task = task
        if task.dateInterval == nil {
            self.task.dateInterval = Interval(start: Date().currentTimeZone(), duration: 3600)
        }
        
        self.toDoViewController = toDoViewController

        self.mode = mode
        self.oldIdx = oldIdx
    }
    
    @objc func fromButtonTapped() {
        fromButton.setTitleColor(.white, for: .normal)
        toButton.setTitleColor(.lightText, for: .normal)
        
        fromDatePicker.isHidden.toggle()
        if !fromDatePicker.isHidden {
            fromButton.setTitle("\(fromDatePicker.date.currentTimeZone().formattedDateAndTime())", for: .normal)
            toDatePicker.isHidden = true
        } else {
            fromButton.setTitle("--/-- --:--", for: .normal)
        }
    }
    
    @objc func toButtonTapped() {
        toButton.setTitleColor(.white, for: .normal)
        fromButton.setTitleColor(.lightText, for: .normal)
        
        toDatePicker.isHidden.toggle()
        if !toDatePicker.isHidden {
            toButton.setTitle("\(toDatePicker.date.currentTimeZone().formattedDateAndTime())", for: .normal)
            fromDatePicker.isHidden = true
        } else {
            toButton.setTitle("--/-- --:--", for: .normal)
        }
    }
    
    @objc func fromPickerValueChanged() {
        fromButton.setTitle("\(fromDatePicker.date.currentTimeZone().formattedDateAndTime())", for: .normal)
        if fromDatePicker.date > toDatePicker.date {
            toDatePicker.setDate(fromDatePicker.date, animated: true)
            toButton.setTitle("\(fromDatePicker.date.currentTimeZone().formattedDateAndTime())", for: .normal)
        }
    }
    
    @objc func toPickerValueChanged() {
        toButton.setTitle("\(toDatePicker.date.currentTimeZone().formattedDateAndTime())", for: .normal)
        if fromDatePicker.date > toDatePicker.date {
            fromDatePicker.setDate(toDatePicker.date, animated: true)
            fromButton.setTitle("\(toDatePicker.date.currentTimeZone().formattedDateAndTime())", for: .normal)
        }
    }
    
    @objc func cancelButtonTapped() {
        toDoViewController.navigationController?.dismiss(animated: true, completion: nil)
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
        
        self.task.content = contentTextView.text
        self.task.dateInterval = Interval(start: fromButton.title(for: .normal) == "--/-- --:--" ? nil : fromDatePicker.date.currentTimeZone(),
                                          end: toButton.title(for: .normal) == "--/-- --:--" ? nil : toDatePicker.date.currentTimeZone())
        self.task.isFinished = self.task.isFinished != nil ? self.task.isFinished : false
        self.task.category = toDoViewController.toDoList.categories[currentIdx]

        self.toDoViewController.editTask(task: self.task, mode: mode, oldIdx: oldIdx)

        toDoViewController.navigationController?.dismiss(animated: true, completion: nil)
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
    
    @objc func categoryButtonTapped() {
        let toDoCategoryTableViewController = ToDoEditCategoryViewController()
        toDoCategoryTableViewController.updateValues(toDoEditViewController: self)

        navigationController?.present(ToDoCategoryNavigationViewController(rootViewController: toDoCategoryTableViewController), animated: true, completion: nil)
    }
    
    @objc func deleteButtonTapped() {
        self.toDoViewController.editTask(task: self.task, mode: "d", oldIdx: oldIdx)

        toDoViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}
