//
//  CourseEditTextTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/8/22.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseEditTextTableViewCell: UITableViewCell {

    // MARK: - Views
    
    var label: UILabel = {
        var label = UILabel()
        
        label.textColor = .white
        
        return label
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        
        textField.textColor = .white

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
        
        // Label/
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(contentView.frame.width * 0.06)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        // Text field.
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(contentView.frame.width * 0.36)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.65)
        }
    }
    
    func updateValues(labelText: String) {
        label.text = labelText
    }
}
