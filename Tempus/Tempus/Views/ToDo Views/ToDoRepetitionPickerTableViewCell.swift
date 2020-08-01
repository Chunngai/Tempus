//
//  ToDoRepetitionPickerTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/8/1.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoRepetitionPickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    // Controllers.
    var delegate: ToDoEditRepetitionViewController!
    
    var repetitionNumbers = [1..<366, 1..<53, 1..<13]
    var repetitionIntervals = ["Day", "Week", "Month"]
    
    var selectedRepetitionNumberIdx = 0
    var selectedRepetitionIntervalIdx = 0
    
    // MARK: - Views
    
    var pickerView: UIPickerView!
    
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
    
    // Customized funcs
    
    func updateInitialViews() {
        backgroundColor = UIColor.sky.withAlphaComponent(0)
        selectionStyle = .none
        
        // Picker.
        pickerView = UIPickerView()
        contentView.addSubview(pickerView)

        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(0, inComponent: 1, animated: true)
        
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        
        pickerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().offset(UIScreen.main.bounds.width * 0.02)
            make.height.equalToSuperview()
        }
    }
    
    func updateValues(delegate: ToDoEditRepetitionViewController) {
        self.delegate = delegate
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {  // Numbers.
            return repetitionNumbers[selectedRepetitionIntervalIdx].max()!
        } else {  // Intervals.
            return repetitionIntervals.count
        }
    }
    
    // MARK: - Picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {  // Numbers.
            return String(row + 1)
        } else {  // Intervals.
            var title = repetitionIntervals[row]
            if selectedRepetitionNumberIdx > 0 {
                title += "s"
            }
            
            return title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {  // The number is changed.
            // If the number is greater than 1, adds an "s" at the end of the interval text.
            selectedRepetitionNumberIdx = row
            pickerView.reloadComponent(1)
        }
        
        if component == 1 {  // The interval is changed.
            // Changes the number range.
            selectedRepetitionIntervalIdx = row
            pickerView.reloadComponent(0)
        }
        
        // Update the text on the delegate.
        delegate.pickerValueChanged(number: selectedRepetitionNumberIdx + 1, interval: repetitionIntervals[selectedRepetitionIntervalIdx])
    }
}

protocol ToDoRepetitionPickerTableViewCellDelegate {
    func pickerValueChanged(number: Int, interval: String)
}
