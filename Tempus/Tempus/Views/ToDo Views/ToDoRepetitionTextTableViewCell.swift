//
//  ToDoRepetitionTextTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/8/5.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoRepetitionTextTableViewCell: UITableViewCell {
    
    // MARK: - Controllers
    
    var delegate: ToDoEditRepetitionViewController!
    var row: Int!
    
    // MARK: - Views
    
    var leftButton = UIButton()
    var rightButton = UIButton()
    
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
    
    // MARK: - Customized funcs
    
    func updateInitialViews() {
        backgroundColor = UIColor.sky.withAlphaComponent(0)
        selectionStyle = .none
        
        // Left buttons.
        contentView.addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
        leftButton.contentHorizontalAlignment = .left
        
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        // Right buttons.
        contentView.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        rightButton.contentHorizontalAlignment = .right
        
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
    }
    
    func updateValues(delegate: ToDoEditRepetitionViewController, row: Int, leftText: String, rightText: String, color: UIColor) {
        self.delegate = delegate
        self.row = row
        
        leftButton.setTitle(leftText, for: .normal)
        rightButton.setTitle(rightText, for: .normal)
        setButtonColor(color: color)
    }
    
    func setButtonColor(color: UIColor) {
        leftButton.setTitleColor(color, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
    }
    
    @objc func leftButtonTapped() {
        delegate.cellTapped(row: row, side: "L")
    }
    
    @objc func rightButtonTapped() {
        delegate.cellTapped(row: row, side: "R")
    }
}

protocol ToDoRepetitionTextTableViewCellDelegate {
    func cellTapped(row: Int, side: String)
}
