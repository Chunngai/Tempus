//
//  ToDoCategoryTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/6/14.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoCategoryTableViewCell: UITableViewCell {
    
    // MARK: Views
    
    var textField: UITextField = {
        let textField = UITextField()
        
        textField.textColor = .white

        return textField
    }()
    var taskNumberLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white

        return label
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
    
    // MARK: - Customized initializers
    
    func updateInitialViews() {
        backgroundColor = UIColor.sky.withAlphaComponent(0)
        selectionStyle = .none
        
        // Text field.
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(15)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)  // Without it new categories cannnot be editted.
        }
        
        // Task number.
        contentView.addSubview(taskNumberLabel)
        taskNumberLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.top)
        }
    }
    
    func updateValues(text: String, taskNumber: Int? = nil) {
        textField.text = text
        
        if let taskNumber = taskNumber {
            taskNumberLabel.text = String(taskNumber)
        }
    }
}
