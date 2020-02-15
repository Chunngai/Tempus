//
//  AssignmentTableViewHeaderFooterView.swift
//  Tempus
//
//  Created by Sola on 2020/2/13.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentsTableViewHeaderView: UITableViewHeaderFooterView {
    
    var course: Course?
    
    var view: UIView!
    var courseNameLabel: UILabel!
    var advancementLabel: UILabel!
    
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
        
        updateView()
    }
    
    func updateView() {
        // Creates a view.
        // TODO: f
        view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        contentView.addSubview(view)
               
        // Creates a course name label.
        // TODO: f
        let courseNameLabelX: CGFloat = 30
        let courseNameLabelY: CGFloat = view.bounds.height - 20
        let courseNameLabelWidth: CGFloat = 100
        let courseNameLabelHeight: CGFloat = 10
        
        courseNameLabel = UILabel(frame: CGRect(x: courseNameLabelX, y: courseNameLabelY, width: courseNameLabelWidth, height: courseNameLabelHeight))
        view.addSubview(courseNameLabel)
        
        courseNameLabel.textColor = .systemGray
        courseNameLabel.font = UIFont.systemFont(ofSize: 13)
        
        // Creates an advancementLabel.
        // TODO: f
        let advancementWidth: CGFloat = 60
        let advancementLabelHeight: CGFloat = 10
        let advancementLabelX = view.bounds.width - 30 - advancementWidth
        let advancementLabelY = view.bounds.height - 20
        
        advancementLabel = UILabel(frame: CGRect(x: advancementLabelX, y: advancementLabelY, width: advancementWidth, height: advancementLabelHeight))
        view.addSubview(advancementLabel)
        
        advancementLabel.textColor = .systemGray
        advancementLabel.font = UIFont.systemFont(ofSize: 13)
        advancementLabel.textAlignment = .right
    }
    
    func updateValues(course: Course) {
        self.course = course
        
        // Updates texts.
        courseNameLabel.text = course.name
        advancementLabel.text = "\(course.dueDateNotBeforeTodayAndFinishedAssignmentNumber) / \(course.dueDateNotBeforeTodayOrUnfinishedAssignmentNumber)"
    }
}
