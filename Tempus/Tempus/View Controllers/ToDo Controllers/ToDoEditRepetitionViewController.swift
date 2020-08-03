//
//  ToDoRepetitionViewController.swift
//  Tempus
//
//  Created by Sola on 2020/7/31.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditRepetitionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ToDoRepetitionPickerTableViewCellDelegate {
    
    // MARK: - Models
    
    var repetition: Repetition? {
        didSet {
            if let neverCell = toDoEditRepetitionTableView?.cellForRow(at: IndexPath(row: 0, section: 0)),
                let repetitionCell = toDoEditRepetitionTableView?.cellForRow(at: IndexPath(row: 1, section: 0)) {
        
                isPickerHidden = repetition == nil ? true : false
                neverCell.textLabel?.textColor = repetition == nil ? .white : .lightText
                repetitionCell.textLabel?.textColor = repetition == nil ? .lightText : .white
            }
        }
    }
    
    let defaultRepetition = Repetition(repetition: (number: 1, intervalIdx: 0))
    
    // MARK: - Controllers
    
    var delegate: ToDoEditViewController!
    
    var isPickerHidden = true
    
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
        isPickerHidden = repetition == nil ? true : false
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
        var cell: UITableViewCell
        if indexPath.row != 2 {  // Text cell.
            cell = UITableViewCell(style: .default, reuseIdentifier: "toDoRepetitionTableViewCell")
            cell.backgroundColor = UIColor.sky.withAlphaComponent(0)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = "Never"
                cell.textLabel?.textColor = repetition == nil ? .white : .lightText
            } else {
                cell.textLabel?.text = Repetition.formatted(repetition: repetition != nil ? repetition : defaultRepetition)
                cell.textLabel?.textColor = repetition == nil ? .lightText : .white
            }
        } else {  // Picker cell.
            cell = ToDoRepetitionPickerTableViewCell()
            (cell as! ToDoRepetitionPickerTableViewCell).updateValues(delegate: self, repetition: repetition != nil ? repetition! : defaultRepetition)
        }
        
        return cell
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
    
    // MARK: - Todo repetition picker table view cell delegate
    
    func pickerValueChanged(repetition: Repetition) {
        self.repetition = repetition
        if let repetitionCell = toDoEditRepetitionTableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
            repetitionCell.textLabel?.text = Repetition.formatted(repetition: repetition)
        }
    }
}

protocol ToDoEditRepetitionViewControllerDelegate {
    func updateRepetition(repetition: Repetition?)
}
