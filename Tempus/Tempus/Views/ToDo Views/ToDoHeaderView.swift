//
//  ToDoHeaderView.swift
//  Tempus
//
//  Created by Sola on 2020/3/29.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Views
    
    var view: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.aqua.withAlphaComponent(0)

        return view
    }()
    var sectionNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .lightText
        label.textAlignment = .right
        
        return label
    }()
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        updateViews()
    }
    
    // MARK: - Customized initializers
    
    func updateViews() {
        // A view for placing contents.
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().inset(10)
        }
        
        // Section name label.
        view.addSubview(sectionNameLabel)
        sectionNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.bottom.equalToSuperview().inset(-5)
            make.width.equalTo(300)
        }
    }
    
    func updateValues(sectionName: String) {
        // Updates the section name.
        sectionNameLabel.text = sectionName
    }
}
