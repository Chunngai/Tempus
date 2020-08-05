//
//  ToDoRepetitionViewController.swift
//  Tempus
//
//  Created by Sola on 2020/7/31.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditRepetitionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ToDoRepetitionPickerTableViewCellDelegate, ToDoRepetitionTextTableViewCellDelegate {
    
    // MARK: - Models
    
    var repetition: Repetition? {
        didSet {
            if let neverCell = toDoEditRepetitionTableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? ToDoRepetitionTextTableViewCell,
                let repetitionCell = toDoEditRepetitionTableView?.cellForRow(at: IndexPath(row: 1, section: 0)) as? ToDoRepetitionTextTableViewCell {
        
                isPickerHidden = repetition == nil ? true : false
                neverCell.setButtonColor(color: neverCellTextColor)
                repetitionCell.setButtonColor(color: repetitionCellTextColor)
            }
        }
    }
    
    let defaultRepetition = Repetition(repetition: (number: 1, intervalIdx: 0), repeatTueDate: Date().currentTimeZone())
    
    // MARK: - Controllers
    
    var delegate: ToDoEditViewController!
    
    var isPickerHidden = true
    var side: String = "L"
    
    var neverCellTextColor: UIColor {
        return repetition == nil ? .white : .lightText
    }
    var repetitionCellTextColor: UIColor {
        return repetition == nil ? .lightText : .white
    }
    
    // MARK: - Views
    
    var toDoEditRepetitionTableView: UITableView!
        
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Customized funcs
    
    func updateViews() {
        view.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        
        // Title of navigation item.
        navigationItem.title = "Repetition"
    
        // Bar button item.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        // Table view.
        toDoEditRepetitionTableView = UITableView(frame: CGRect(x: 0,
                                                                y: navigationController!.navigationBar.frame.height,
                                                                width: view.frame.width,
                                                                height: view.frame.height - navigationController!.navigationBar.frame.height),
                                                  style: .plain)
        view.addSubview(toDoEditRepetitionTableView)
        
        toDoEditRepetitionTableView.dataSource = self
        toDoEditRepetitionTableView.delegate = self
                
        toDoEditRepetitionTableView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        toDoEditRepetitionTableView.separatorStyle = .none
    }
    
    func updateValues(delegate: ToDoEditViewController, repetition: Repetition?) {
        self.delegate = delegate
        
        self.repetition = repetition
    }
    
    @objc func doneButtonTapped() {
        delegate.updateRepetition(repetition: repetition)
        
        delegate.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tmpRepetition = repetition != nil ? repetition : defaultRepetition

        if indexPath.row != 2 {  // Text cell.
            let cell = ToDoRepetitionTextTableViewCell()
            
            if indexPath.row == 0 {
                cell.updateValues(delegate: self, row: indexPath.row, leftText: "Never", rightText: "", color: neverCellTextColor)
            } else {
                cell.updateValues(delegate: self, row: indexPath.row, leftText: Repetition.formatted(repetition: tmpRepetition),
                                  rightText: tmpRepetition!.formattedRepeatTilDate, color: repetitionCellTextColor)
            }
            
            return cell
        } else {  // Picker cell.
            let cell = ToDoRepetitionPickerTableViewCell()
            cell.updateValues(delegate: self, repetition: tmpRepetition!)
            
            return cell
        }
    }
    
    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pickerCell = toDoEditRepetitionTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ToDoRepetitionPickerTableViewCell {
            if indexPath.row == 0 {
                repetition = nil
            } else if indexPath.row == 1 {
                repetition = pickerCell.repetition
            }
            
            // Displays or hides the picker.
            toDoEditRepetitionTableView.beginUpdates()
            toDoEditRepetitionTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return isPickerHidden ? 0 : 200
        } else {
            return 44
        }
    }
    
    // MARK: - Todo repetition text table view cell delegate
    
    func cellTapped(row: Int, side: String) {
        if let cell = toDoEditRepetitionTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ToDoRepetitionPickerTableViewCell {
            cell.updateDisplayingPicker(side: side)
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        tableView(toDoEditRepetitionTableView, didSelectRowAt: indexPath)
    }
    
    // MARK: - Todo repetition picker table view cell delegate
    
    func datePickerValueChanged(repetition: Repetition) {
        self.repetition = repetition
        if let repetitionCell = toDoEditRepetitionTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ToDoRepetitionTextTableViewCell {
            repetitionCell.rightButton.setTitle(repetition.formattedRepeatTilDate, for: .normal)
        }
    }
    
    func pickerValueChanged(repetition: Repetition) {
        self.repetition = repetition
        if let repetitionCell = toDoEditRepetitionTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ToDoRepetitionTextTableViewCell {
            repetitionCell.leftButton.setTitle(Repetition.formatted(repetition: repetition), for: .normal)
        }
    }
}

protocol ToDoEditRepetitionViewControllerDelegate {
    func updateRepetition(repetition: Repetition?)
}
