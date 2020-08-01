//
//  ToDoRepetitionViewController.swift
//  Tempus
//
//  Created by Sola on 2020/7/31.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditRepetitionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ToDoRepetitionPickerTableViewCellDelegate {
    
    // MARK: - Controllers
    
    var delegate: ToDoEditViewController!
    
    var isPickerHidden = true
    
    var repetitionNumber = 1
    var repetitionInterval = "Day"
    
    var repetitionText: String {
        return "Every \(repetitionNumber) \(repetitionNumber > 1 ? repetitionInterval + "s" : repetitionInterval)"
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
    
        // Bar button items.
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
    
    func updateValues(delegate: ToDoEditViewController) {
        self.delegate = delegate
    }
    
    @objc func doneButtonTapped() {
        
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
        if indexPath.row == 0 || indexPath.row == 1 {  // Text cell.
            cell = UITableViewCell(style: .default, reuseIdentifier: "toDoRepetitionTableViewCell")
            cell.backgroundColor = UIColor.sky.withAlphaComponent(0)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = "Never"
                cell.textLabel?.textColor = .white
            } else {
                cell.textLabel?.text = repetitionText
                cell.textLabel?.textColor = .lightText
            }
        } else {  // Picker cell.
            cell = ToDoRepetitionPickerTableViewCell()
            (cell as! ToDoRepetitionPickerTableViewCell).updateValues(delegate: self)
        }
        
        return cell
    }
    
    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let neverCell = toDoEditRepetitionTableView.cellForRow(at: IndexPath(row: 0, section: 0)),
            let repetitionCell = toDoEditRepetitionTableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
            
            if indexPath.row == 0 {
                neverCell.textLabel?.textColor = .white
                repetitionCell.textLabel?.textColor = .lightText
                
                isPickerHidden = true
            } else if indexPath.row == 1 {
                neverCell.textLabel?.textColor = .lightText
                repetitionCell.textLabel?.textColor = .white
                
                isPickerHidden = false
            }
            // Displays or hides the picker.
            toDoEditRepetitionTableView.beginUpdates()
            toDoEditRepetitionTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return isPickerHidden ? 0 : 220
        } else {
            return 44
        }
    }
    
    // MARK: - Todo repetition picker table view cell delegate
    func pickerValueChanged(number: Int, interval: String) {
        repetitionNumber = number
        repetitionInterval = interval
        if let repetitionCell = toDoEditRepetitionTableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
            repetitionCell.textLabel?.text = repetitionText
        }
    }
}
