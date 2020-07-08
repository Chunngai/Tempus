//
//  ToDoTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/3/28.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ToDoTableViewCell: UITableViewCell {
    // Models.
    var task: Task!
    
    // Controllers.
    var toDoViewController: ToDoViewController!
        
    // Views.
    var view = UIView()
    var dateLabel: UILabel!
    var remainingTimeLabel: UILabel!
    var contentLabel = UILabel()
    
    var gradientLayer = CAGradientLayer()
    
    // Initializers.
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
    
    // Customized funcs.
    func updateInitialViews() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.sky.withAlphaComponent(0)
        
        // A view for placing contents.
        contentView.addSubview(view)
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        // Content label.
        view.addSubview(contentLabel)
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentLabel.textColor = .white
        
        // Gradient layer.
        view.addGradientLayer(gradientLayer: gradientLayer,
                              colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
                              locations: [0.0, 1.0],
                              startPoint: CGPoint(x: 0, y: 1),
                              endPoint: CGPoint(x: 1, y: 1),
                              frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        // Long press to edit.
        let longPressedGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed))
        view.addGestureRecognizer(longPressedGestureRecognizer)
    }
    
    func updateValues(task: Task, toDoViewController: ToDoViewController) {
        self.task = task
        self.toDoViewController = toDoViewController

        // Updates the views.
        if task.dateInterval != nil && (task.dateInterval.start != nil || task.dateInterval.end != nil) {  // When start or end provided.
            // Date label.
            dateLabel = UILabel()
            
            view.addSubview(dateLabel)
            
            dateLabel.text = getDateLabelText(dateInterval: task.dateInterval)
            dateLabel.textColor = .lightText
            
            dateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
                make.top.equalToSuperview().offset(15)
                make.width.equalTo(300)
            }
            
            // Remaining time label.
            remainingTimeLabel = UILabel()
            
            view.addSubview(remainingTimeLabel)
            
            remainingTimeLabel.textAlignment = .right
            remainingTimeLabel.text = getRemainingTimeLabelText(task: task)
            remainingTimeLabel.textColor = getRemainingTimeLabelTextColor(task: task)
        
            remainingTimeLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
                make.top.equalTo(dateLabel.snp.top)
                make.width.equalTo(100)
            }
            
            // Modifies the constraints of the content label.
            contentLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
                make.top.equalTo(dateLabel.snp.bottom).offset(8)
                make.bottom.equalToSuperview().inset(15)
            }
        } else {
            contentLabel.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
                make.top.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().inset(15)
            }
        }
        
        // Content label.
        contentLabel.text = task.content
    }
    
    @objc func viewLongPressed() {
        if let toDoEditNavigationViewController = toDoViewController.presentedViewController,
            toDoEditNavigationViewController is ToDoEditNavigationViewController {
            return
        }
        
        toDoViewController.presentEditingView(task: task)
    }
    
    func getDateLabelText(dateInterval: Interval) -> String {
        if let dateIntervalStart = dateInterval.start, let dateIntervalEnd = dateInterval.end {
            return "\(dateIntervalStart.formattedDateAndTime(omitZero: true)) - \(dateIntervalEnd.formattedDateAndTime(omitZero: true, withWeekday: true))"
        } else if dateInterval.start != nil  {
            return "\(dateInterval.start!.formattedDateAndTime(omitZero: true)) -"
        } else if dateInterval.end != nil {
            return "- \(dateInterval.end!.formattedDateAndTime(omitZero: true, withWeekday: true))"
        } else {
            return "--/-- --:--"
        }
    }
    
    func getRemainingTimeLabelText(task: Task) -> String {
        if task.isOverdue {
            return "Overdue"
        } else {
            if let start = task.dateInterval.start, Date().dateOfCurrentTimeZone() < start {  // Start provided.
                return DateInterval(start: Date().dateOfCurrentTimeZone(), end: start).formatted(omitZero: true)
            } else if let due = task.dateInterval.end, Date().dateOfCurrentTimeZone() < due {  // Due provided.
                return DateInterval(start: Date().dateOfCurrentTimeZone(), end: due).formatted(omitZero: true)
            } else {  // Neither provided.
                return ""
            }
        }
    }
    
    func getRemainingTimeLabelTextColor(task: Task) -> UIColor {
        if task.isOverdue {
            return .yellow
        } else {
            if let start = task.dateInterval.start, Date().dateOfCurrentTimeZone() < start {  // Before start.
                if DateInterval(start: Date().dateOfCurrentTimeZone(), end: start).getComponents([.day]).day! < 3 {  // Less than 3 days.
                    return .orange
                } else {  // More than 3 days.
                    return .lightText
                }
            } else if let due = task.dateInterval.end, Date().dateOfCurrentTimeZone() < due {  // Before end.
                if DateInterval(start: Date().dateOfCurrentTimeZone(), end: due).getComponents([.day]).day! < 3 {  // Less than 3 days.
                    return .red
                } else if task.dateInterval.start != nil {  // Doing.
                    return .purple
                } else {  // More than 3 days.
                    return .lightText
                }
            } else {  // Neither provided.
                return .lightText
            }
        }
    }
}
