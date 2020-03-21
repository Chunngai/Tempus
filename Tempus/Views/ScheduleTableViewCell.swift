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
    
    // Data source.
    var task: Task?
    
    // Views.
    var view: UIView!
    var timeLabel: UILabel!
    var contentLabel: UILabel!
    
    var gradientLayer: CAGradientLayer!
    
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
        self.backgroundColor = .white
        
        // Creates a view.
        view = UIView()
        contentView.addSubview(view)

        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().inset(15)
        }
        
        // Creates a time label.
        timeLabel = UILabel()
        view.addSubview(timeLabel)
                
        timeLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(15)
        }
        
        // Creates a content label.
        contentLabel = UILabel()
        view.addSubview(contentLabel)
        
        contentLabel.numberOfLines = 6
        contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(15)
        }
        
        // Gradient layer as bg color.
        gradientLayer = CAGradientLayer()

    }
    
    func updateValues(task: Task) {
        self.task = task
        
        // Updates texts of labels.
        let timeLabelText = "\(task.dateInterval.start.formattedTime()) - \(task.dateInterval.end.formattedTime())"
        
        let contentLabelText = task.content
//        contentLabel.sizeToFit()
        
        // Updates status
        var textAttrs: [NSAttributedString.Key: Any] = [:]
        var gradientLayerColors: [CGColor] = []
        if task.isFinished {
            textAttrs[.foregroundColor] = UIColor.lightGray
            textAttrs[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            textAttrs[.strikethroughColor] = UIColor.lightGray
            
            timeLabel.attributedText = NSAttributedString(string: timeLabelText, attributes: textAttrs)
            contentLabel.attributedText = NSAttributedString(string: contentLabelText, attributes: textAttrs)
            
            gradientLayerColors = [UIColor.aqua.withAlphaComponent(0.2).cgColor, UIColor.sky.withAlphaComponent(0.2).cgColor]
        } else {
            textAttrs[.strikethroughStyle] = nil
            textAttrs[.strikethroughColor] = nil

            textAttrs[.foregroundColor] = UIColor.lightText
            timeLabel.attributedText = NSAttributedString(string: timeLabelText, attributes: textAttrs)
            textAttrs[.foregroundColor] = UIColor.white
            contentLabel.attributedText = NSAttributedString(string: contentLabelText, attributes: textAttrs)
            
            gradientLayerColors = [UIColor.aqua.cgColor, UIColor.sky.cgColor]
        }
        
        // Creates a gradient layer.
        view.addGradientLayer(gradientLayer: gradientLayer,
            colors: gradientLayerColors,
            locations: [0.0, 1.0],
            startPoint: CGPoint(x: 0, y: 1),
            endPoint: CGPoint(x: 1, y: 1),
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
}
