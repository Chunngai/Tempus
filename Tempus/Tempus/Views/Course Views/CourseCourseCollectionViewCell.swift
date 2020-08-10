//
//  CourseCourseCollectionViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/8/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseCourseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    var courseLabel: UILabel = {
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
    
    // MARK: - Customized funcs
    
    func updateViews() {        
        contentView.addSubview(courseLabel)
        courseLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
