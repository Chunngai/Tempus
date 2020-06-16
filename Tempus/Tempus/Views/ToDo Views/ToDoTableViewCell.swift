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
    
    var task: Task!
    var toDoViewController: ToDoViewController!
        
    // Views.
    var view = UIView()
    var dateLabel: UILabel!
    var remainingTimeLabel: UILabel!
    var contentLabel = UILabel()
    
    var gradientLayer = CAGradientLayer()
    
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
        
        updateInitialViews()
    }
    
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
        
//        contentLabel.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
//            make.top.equalToSuperview().offset(15)
//            make.bottom.equalToSuperview().inset(15)
//        }
        
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
        if task.dateInterval != nil && (task.dateInterval.start != nil || task.dateInterval.end != nil) {
            // Date label.
            dateLabel = UILabel()
            
            view.addSubview(dateLabel)
                    
            if let taskDateIntervalStart = task.dateInterval.start, let taskDateIntervalEnd = task.dateInterval.end {
                dateLabel.text = "\(taskDateIntervalStart.formattedDateAndTime(omitZero: true)) - \(taskDateIntervalEnd.formattedDateAndTime(omitZero: true))"
            } else if task.dateInterval.start != nil  {
                dateLabel.text = "\(task.dateInterval.start!.formattedDateAndTime(omitZero: true)) -"
            } else if task.dateInterval.end != nil {
                dateLabel.text = "- \(task.dateInterval.end!.formattedDateAndTime(omitZero: true))"
            } else {
                dateLabel.text = "--/-- --:--"
            }
            dateLabel.textColor = .lightText
            
            dateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
                make.top.equalToSuperview().offset(15)
                make.width.equalTo(230)
            }
            
            // Remaining time label.
            remainingTimeLabel = UILabel()
            
            view.addSubview(remainingTimeLabel)
            
            if let taskDateIntervalEnd = task.dateInterval.end {
                if Date().dateOfCurrentTimeZone() <= taskDateIntervalEnd {
                    remainingTimeLabel.text = "\(DateInterval(start: Date().dateOfCurrentTimeZone(), end: taskDateIntervalEnd).formatted(omitZero: true))"
                } else {
                    remainingTimeLabel.text = "Overdue"
                }
            } else {
                remainingTimeLabel.text = ""
            }
            remainingTimeLabel.textAlignment = .right
            if task.dateInterval.end != nil {
                remainingTimeLabel.textColor = getRemainingTimeTextColor()
            } else {
                remainingTimeLabel.textColor = .lightText
            }
            
            remainingTimeLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
                make.top.equalTo(dateLabel.snp.top)
                make.width.equalTo(200)
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
        contentLabel.text = task.content
    }
    
    func getRemainingTimeTextColor() -> UIColor {
        if Date().dateOfCurrentTimeZone() <= task.dateInterval.end! {
            let components = DateInterval(start: Date().dateOfCurrentTimeZone(), end: task.dateInterval.end!).getComponents([.month, .day])
            
            return components.month! == 0 && components.day! >= 3 ? UIColor.lightText : UIColor.red
        } else {
            return .yellow
        }
    }
    
    @objc func viewLongPressed() {
        if let toDoEditNavigationViewController = toDoViewController.presentedViewController,
            toDoEditNavigationViewController is ToDoEditNavigationViewController {
            return
        }
        
        toDoViewController.presentEditingView(task: task)
    }
}
