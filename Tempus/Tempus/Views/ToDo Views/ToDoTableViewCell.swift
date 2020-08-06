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
    
    // MARK: Models
    
    var task: Task!
    
    // MARK: - Controllers
    
    var delegate: ToDoViewController!
        
    // MARK: - Views
    
    var view = UIView()
    var dateLabel: UILabel!
    var remainingTimeLabel: UILabel!
    var contentLabel = UILabel()
    
    var gradientLayer = CAGradientLayer()
    
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
        view.addGradientLayer(endPoint: CGPoint(x: 1, y: 1),
                              frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        // Long press to edit.
        let longPressedGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed))
        view.addGestureRecognizer(longPressedGestureRecognizer)
        
        // Double Taps to toggle finish status.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDoubleTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer.numberOfTapsRequired = 2
    }
    
    func updateValues(task: Task, delegate: ToDoViewController) {
        self.task = task
        self.delegate = delegate

        // Updates the views.
        if task.dateInterval != nil && (task.dateInterval.start != nil || task.dateInterval.end != nil) {  // When start or end provided.
            // Date label.
            dateLabel = UILabel()
            
            view.addSubview(dateLabel)
            
            dateLabel.text = getDateLabelText(task: task)
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
        if let toDoEditNavigationViewController = delegate.presentedViewController,
            toDoEditNavigationViewController is ToDoEditNavigationController {
            return
        }
        
        delegate.presentEditingView(task: task)
    }
    
    @objc func viewDoubleTapped() {
        delegate.toggleFinishStatus(task: task)
    }
    
    func getDateLabelText(task: Task) -> String {
        let dateInterval = task.dateInterval!
        
        if let dateIntervalStart = dateInterval.start, let dateIntervalEnd = dateInterval.end {
            var text = "\(dateIntervalStart.formattedDateAndTime(omitZero: true)) - \(dateIntervalEnd.formattedDateAndTime(omitZero: true, withWeekday: true))"
            if task.repetition != nil {
                text += " ↻"
            }
            return text
        } else if dateInterval.start != nil  {
            return "\(dateInterval.start!.formattedDateAndTime(omitZero: true)) -"
        } else if dateInterval.end != nil {
            return "- \(dateInterval.end!.formattedDateAndTime(omitZero: true, withWeekday: true))"
        } else {
            return "--/-- --:--"
        }
    }
    
    func getRemainingTimeLabelText(task: Task) -> String {
//        if task.isFinished {
//            return ""
//        } else if task.isOverdue {
//            return "Overdue"
//        } else {
//            if let start = task.dateInterval.start, Date().currentTimeZone() < start {  // Start provided.
//                return DateInterval(start: Date().currentTimeZone(), end: start).formatted(omitZero: true)
//            } else if let due = task.dateInterval.end, Date().currentTimeZone() < due {  // Due provided.
//                return DateInterval(start: Date().currentTimeZone(), end: due).formatted(omitZero: true)
//            } else {  // Neither provided.
//                return ""
//            }
//        }
        if task.isEmergent {
            // Remaining time before due.
            return DateInterval(start: Date().currentTimeZone(), end: task.dateInterval.end!).formatted(omitZero: true)
        } else if task.isBeforeSoon || task.isSoon {
            // Remaining time before start.
            return DateInterval(start: Date().currentTimeZone(), end: task.dateInterval.start!).formatted(omitZero: true)
        } else if task.isDoing {
            // Remaining time before due.
            return DateInterval(start: Date().currentTimeZone(), end: task.dateInterval.end!).formatted(omitZero: true)
        } else if task.isOverdue {
            return "Overdue"
        } else {
            return ""
        }
    }
    
    func getRemainingTimeLabelTextColor(task: Task) -> UIColor {
//        if task.isFinished {
//            return .lightText
//        } else if task.isOverdue {
//            return .yellow
//        } else {
//            if let start = task.dateInterval.start, Date().currentTimeZone() < start {  // Before start.
//                if DateInterval(start: Date().currentTimeZone(), end: start).getComponents([.day]).day! < 3 {  // Less than 3 days.
//                    return .orange
//                } else {  // More than 3 days.
//                    return .lightText
//                }
//            }
//            if let due = task.dateInterval.end, Date().currentTimeZone() < due {  // Before end.
//                if DateInterval(start: Date().currentTimeZone(), end: due).getComponents([.day]).day! < 3 {  // Less than 3 days.
//                    return .red
//                } else if task.dateInterval.start != nil {  // Doing.
//                    return .purple
//                } else {  // More than 3 days.
//                    return .lightText
//                }
//            } else {  // Neither provided.
//                return .lightText
//            }
//        }
        if task.isEmergent {
            return .red
        }
        if task.isBeforeSoon {
            return .lightText
        }
        if task.isSoon {
            return .orange
        }
        if task.isDoing {
            return .purple
        }
        if task.isOverdue {
            return .yellow
        }
        
        return .lightText
    }
}

protocol ToDoTableViewCellDelegate {
    func presentEditingView(task: Task)
    
    func toggleFinishStatus(task: Task)
}
