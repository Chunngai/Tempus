//
//  TimetableClassTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/2/6.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class TimetableClassTableViewCell: UITableViewCell {

    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var classroomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(class_: Class_) {
        //self.backgroundColor = .black
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        courseNameLabel.font = UIFont.systemFont(ofSize: 23)
        courseNameLabel.text = class_.courseName
        //courseNameLabel.textColor = .systemTeal
        
        let classTime = class_.time
        timeLabel.text = "\(classTime.0.hour!):\(classTime.0.minute!) - \(classTime.1.hour!):\(classTime.1.minute!)"
        //timeLabel.textColor = .systemTeal
        
        classroomLabel.textAlignment = .right
        classroomLabel.text = class_.classroom
        //classroomLabel.textColor = .systemTeal
    }
    
}
