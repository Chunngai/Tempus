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
    
    // MARK: - Models
    
    var task: Task!
    
    // MARK: - Controllers
    
    var delegate: ScheduleViewController!
    
    // MARK: - Views
    
    var view: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.addGradientLayer(endPoint: CGPoint(x: 1, y: 1),
                              frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        return view
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .lightText
        
        return label
    }()
    var durationLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.textColor = .lightText
        
        return label
    }()
    var contentLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
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
        
        // Time label.
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(200)
        }
        
        // Duration label.
        view.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(timeLabel.snp.top)
            make.width.equalTo(200)
        }
        
        // Content label.
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(view).inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(15)
        }
        
        // Long press to edit.
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed))
        view.addGestureRecognizer(longPressGestureRecognizer)
        
        // Taps to toggle finish status.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateValues(task: Task, delegate: ScheduleViewController) {
        self.task = task
        
        self.delegate = delegate
                
        let timeLabelText = "\(task.dateInterval.start!.formattedTime()) - \(task.dateInterval.end!.formattedTime())"
        let durationLabelText = "\(task.dateInterval.duration!.formattedDuration())"
        let contentLabelText = task.content!
        
        // Config text attrs according to the finish status.
        var textAttrs: [NSAttributedString.Key: Any] = [:]
        if task.isFinished {
            textAttrs = [.foregroundColor: UIColor.lightText,
                         .strikethroughStyle: NSUnderlineStyle.single.rawValue]
            
            contentLabel.textColor = .lightGray
        } else {
            textAttrs = [:]
            
            contentLabel.textColor = .white
        }
        timeLabel.attributedText = NSAttributedString(string: timeLabelText, attributes: textAttrs)
        durationLabel.attributedText = NSAttributedString(string: durationLabelText, attributes: textAttrs)
        contentLabel.attributedText = NSAttributedString(string: contentLabelText, attributes: textAttrs)
    }
    
    // MARK: - Customized funcs
    
    @objc func viewLongPressed() {
        if let scheduleEditNavigationViewController = delegate.presentedViewController,
            scheduleEditNavigationViewController is ScheduleEditNavigationController {
            return
        }
        
        delegate.presentEditingView(task: task)
    }
    
    @objc func viewTapped() {
        if !delegate.editable {
            return
        }
        
        delegate.toggleFinishStatus(task: task)
    }
}


protocol ScheduleTableViewCellDelegate {
    func presentEditingView(task: Task)
    
    func toggleFinishStatus(task: Task)
}
