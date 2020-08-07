//
//  ToDoRepetitionPickerTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/8/1.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoRepetitionPickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Models
    
    var repetition: Repetition!
    var repetitionNumberIdx: Int {
        return repetition.number - 1
    }
    var repetitionIntervalIdx: Int {
        return repetition.intervalIdx
    }
    
    // MARK: - Controllers
    
    var delegate: ToDoEditRepetitionViewController!
    
    // MARK: - Views
    
    var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        
        return pickerView
    }()
    var selectedNumberIdx: Int {
        return pickerView.selectedRow(inComponent: 0)
    }
    var selectedIntervalIdx: Int {
        return pickerView.selectedRow(inComponent: 1)
    }
    
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.isHidden = true
        
        return datePicker
    }()
    
    // MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        updateInitialViews()
    }
    
    // Customized initializers
    
    func updateInitialViews() {
        backgroundColor = UIColor.sky.withAlphaComponent(0)
        selectionStyle = .none
        
        // Picker.
        contentView.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.02)
            make.right.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.02)
            make.height.equalToSuperview()
        }
        
        // Date picker.
        contentView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.02)
            make.right.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.02)
            make.height.equalToSuperview()
        }
    }
    
    func updateValues(repetition: Repetition, delegate: ToDoEditRepetitionViewController) {
        self.repetition = repetition
        
        self.delegate = delegate
                
        pickerView.selectRow(repetitionNumberIdx, inComponent: 0, animated: true)
        pickerView.selectRow(repetitionIntervalIdx, inComponent: 1, animated: true)
        
        datePicker.date = repetition.repeatTueDate
    }
    
    // MARK: - Customized funcs
    
    func updateDisplayingPicker(side: String) {
        if side == "L" {
            pickerView.isHidden = false
            datePicker.isHidden = true
        } else {
            pickerView.isHidden = true
            datePicker.isHidden = false
        }
    }
    
    @objc func datePickerValueChanged() {
        // Updates the repetition.
        repetition.updateRepetitionRepeatTueDate(repeatTilDate: datePicker.date.currentTimeZone())
        
        // Updates the repetition of the delegate.
        delegate.datePickerValueChanged(repetition: repetition)
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {  // Numbers.
            if pickerView.numberOfComponents == 2 {  // Sometimes it's 1.
                return Repetition.numbers[selectedIntervalIdx].max()!
            } else {
                return 1
            }
        } else {  // Intervals.
            return Repetition.intervals.count
        }
    }
    
    // MARK: - Picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {  // Numbers.
            return String(row + 1)
        } else {  // Intervals.
            var title = Repetition.intervals[row]
            if selectedNumberIdx > 0 {
                title += "s"
            }
            
            return title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Updates the picker view.
        pickerView.reloadAllComponents()
        
        // If the current selected number is greater than the valid number of the current interval, makes the selected number be the max valid one.
        if selectedNumberIdx > pickerView.numberOfRows(inComponent: 0) - 1 {
            pickerView.selectRow(pickerView.numberOfRows(inComponent: 0) - 1, inComponent: 0, animated: true)
        }
        
        // Updates the repetition.
        repetition.updateRepetitionInterval(number: selectedNumberIdx + 1, intervalIdx: selectedIntervalIdx)
        
        // Updates the repetition of the delegate.
        delegate.pickerValueChanged(repetition: repetition)
    }
}

protocol ToDoRepetitionPickerTableViewCellDelegate {
    func datePickerValueChanged(repetition: Repetition)
    
    func pickerValueChanged(repetition: Repetition)
}
