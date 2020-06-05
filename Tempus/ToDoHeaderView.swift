//
//  ToDoHeaderView.swift
//  Tempus
//
//  Created by Sola on 2020/3/29.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoHeaderView: UITableViewHeaderFooterView {

    var view = UIView()
    var sectionNameLabel = UILabel()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        updateViews()
    }
    
    func updateViews() {
        // A view for placing contents.
        contentView.addSubview(view)
        
        view.backgroundColor = UIColor.aqua.withAlphaComponent(0)
        
        view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalToSuperview()
        }
        
        // Section name label.
        view.addSubview(sectionNameLabel)
        
        sectionNameLabel.textColor = .lightText
        sectionNameLabel.textAlignment = .right
        
        sectionNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(0)
            make.width.equalTo(300)
        }
    }
    
    func updateValues(sectionName: String) {
        // Updates the section name.
        sectionNameLabel.text = sectionName
    }
}
