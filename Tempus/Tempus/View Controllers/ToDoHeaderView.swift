//
//  ToDoHeaderView.swift
//  Tempus
//
//  Created by Sola on 2020/3/29.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoHeaderView: UITableViewHeaderFooterView {

    var view: UIView!
    var sectionNameLabel: UILabel!
    
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
        // Creates a view.
        view = UIView()
        contentView.addSubview(view)
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        view.backgroundColor = UIColor.aqua.withAlphaComponent(0)
        
        // Section name label.
        sectionNameLabel = UILabel()
        view.addSubview(sectionNameLabel)
        
        sectionNameLabel.frame = CGRect()
        sectionNameLabel.textColor = .lightText
        sectionNameLabel.textAlignment = .right
//        sectionNameLabel.font = UIFont.systemFont(ofSize: 13)
        
        sectionNameLabel.snp.makeConstraints { (make) in
//            make.trailing.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
////            make.height.equalTo(view.bounds.height - 20)
//            make.width.equalTo(UIScreen.main.bounds.width)
//            make.height.equalTo(16)
            
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
