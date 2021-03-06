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
    
    var view: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.addGradientLayer(endPoint: CGPoint(x: 1, y: 1),
                              frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        return view
    }()
    var dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .lightText
        
        return label
    }()
    var remainingTimeLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        
        return label
    }()
    var contentLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = .white
        
        return label
    }()
        
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
    
    // MARK: - Customized initializers
    
    func updateInitialViews() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.sky.withAlphaComponent(0)
        
        // A view for placing contents.
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        // Content label.
        view.addSubview(contentLabel)
        
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
            view.addSubview(dateLabel)
            dateLabel.text = getDateLabelText(task: task)
            dateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
                make.top.equalToSuperview().offset(15)
                make.width.equalTo(300)
            }
            
            // Remaining time label.
            view.addSubview(remainingTimeLabel)
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
    
    // MARK: - Customized funcs
    
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
