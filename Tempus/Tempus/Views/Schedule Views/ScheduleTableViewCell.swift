//
//  ScheduleTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/3/19.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ScheduleTableViewCell: UITableViewCell {
        
    var task: Task!
    var scheduleViewController: ScheduleViewController!
    
    // Views.
    var view = UIView()
    var timeLabel = UILabel()
    var durationLabel = UILabel()
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
        
        // Time label.
        view.addSubview(timeLabel)
                
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(200)
        }
        
        // Duration label.
        view.addSubview(durationLabel)
        
        durationLabel.textAlignment = .right
        
        durationLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(timeLabel.snp.top)
            make.width.equalTo(200)
        }
        
        // Content label.
        view.addSubview(contentLabel)
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(view).inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(15)
        }
        
        // Gradient layer.
        view.addGradientLayer(gradientLayer: gradientLayer,
                              colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
                              locations: [0.0, 1.0],
                              startPoint: CGPoint(x: 0, y: 1),
                              endPoint: CGPoint(x: 1, y: 1),
                              frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        // Long press to edit.
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed))
        view.addGestureRecognizer(longPressGestureRecognizer)
        
        // Tap to toggle finish status.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateValues(task: Task, scheduleViewController: ScheduleViewController) {
        self.task = task
        self.scheduleViewController = scheduleViewController
        
        // Updates the views.
        let timeLabelText = "\(task.dateInterval.start!.formattedTime()) - \(task.dateInterval.end!.formattedTime())"
        let durationLabelText = "\(task.dateInterval.duration!.formattedDuration())"
        
        let contentLabelText = task.content!
        
        var textAttrs: [NSAttributedString.Key: Any] = [:]
        if task.isFinished {
            textAttrs[.foregroundColor] = UIColor.lightText
            textAttrs[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            textAttrs[.strikethroughColor] = UIColor.lightText
            
            timeLabel.attributedText = NSAttributedString(string: timeLabelText, attributes: textAttrs)
            durationLabel.attributedText = NSAttributedString(string: durationLabelText, attributes: textAttrs)
            contentLabel.attributedText = NSAttributedString(string: contentLabelText, attributes: textAttrs)
        } else {
            textAttrs[.strikethroughStyle] = nil
            textAttrs[.strikethroughColor] = nil

            textAttrs[.foregroundColor] = UIColor.lightText
            timeLabel.attributedText = NSAttributedString(string: timeLabelText, attributes: textAttrs)
            durationLabel.attributedText = NSAttributedString(string: durationLabelText, attributes: textAttrs)
            textAttrs[.foregroundColor] = UIColor.white
            contentLabel.attributedText = NSAttributedString(string: contentLabelText, attributes: textAttrs)
        }
    }
    
    @objc func viewLongPressed() {
        if let scheduleEditNavigationViewController = scheduleViewController.presentedViewController,
            scheduleEditNavigationViewController is ScheduleEditNavigationViewController {
            return
        }
        
        scheduleViewController.presentEditingView(task: task)
    }
    
    @objc func viewTapped() {
        if !scheduleViewController.editable {
            return
        }
        
        scheduleViewController.toggleFinishStatus(task: task)
    }
}
