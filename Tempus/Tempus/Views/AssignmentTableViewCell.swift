//
//  AssignmentTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/2/11.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        updateView()
    }
    
    func updateView() {
        let viewX = (UIScreen.main.bounds.width - contentView.bounds.width) / 2
        let viewY: CGFloat = 0
        let viewWidth = contentView.bounds.width
        let viewHeight:CGFloat = 100
                
        let view = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight))
        view.backgroundColor = .white
        contentView.addSubview(view)
                
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.aqua.cgColor
        view.backgroundColor = UIColor.white
    }
    
    func updateValues(assignment: Task) {
        
    }
}
