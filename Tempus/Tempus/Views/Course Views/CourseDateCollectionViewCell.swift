//
//  CourseDateCollectionViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/8/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseDateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    var rightBorder: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightText
        
        return view
    }()
    var bottomBorder: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightText
        
        return view
    }()
    
    var startTimeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .lightText
        label.font = UIFont.systemFont(ofSize: 12)
//        label.text = "08:00"
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Customized init
    
    func updateViews() {
//        contentView.addSubview(rightBorder)
//        rightBorder.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.width.equalTo(0.5)
//        }
//
//        contentView.addSubview(bottomBorder)
//        bottomBorder.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.height.equalTo(0.5)
//        }
        
        contentView.addSubview(startTimeLabel)
        startTimeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(contentView.bounds.height * 0.01)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
