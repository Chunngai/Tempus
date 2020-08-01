//
//  ToDoRepetitionPickerTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/8/1.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoRepetitionPickerTableViewCell: UITableViewCell {

    // MARK: - Views
    
    var picker: UIDatePicker!
    
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
        picker = UIDatePicker()
        contentView.addSubview(picker)
        
        picker.minimumDate = Date()
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.isHighlighted = false
        picker.datePickerMode = .dateAndTime
        
        picker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().offset(UIScreen.main.bounds.width * 0.02)
            make.height.equalToSuperview()
        }
    }
}
