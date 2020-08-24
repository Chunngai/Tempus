//
//  CourseEditTextTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/8/22.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseEditTextTableViewCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - Views
    
    var label: UILabel = {
        var label = UILabel()
        
        label.textColor = .white
        
        return label
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        
        textField.textColor = .white
        textField.textAlignment = .center

        return textField
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
        
        // Label.
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentView.frame.width * 0.05)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(contentView.frame.width * 0.45)
        }
        
        // Text field.
        contentView.addSubview(textField)
        textField.delegate = self
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentView.frame.width * 0.5)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func updateValues(labelText: String?, textFieldText: String, validIntegers: ClosedRange<Int>?) {
        if let labelText = labelText {
            label.text = labelText
        } else {
            textField.isEnabled = false
        }
        
        textField.text = textFieldText
        
        if validIntegers != nil {
            textField.keyboardType = .numberPad
        }
    }
    
    // MARK: - Text field delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .white
    }
    
    // MARK: - Customized funcs
    
    func switchToWarningColor() {
        textField.textColor = .red
    }
}
