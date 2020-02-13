//
//  AssignmentTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/2/11.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    
    var assignment: Task?
    var delegate: AssignmentsViewController?
    
    var view: UIView!
    var sideBarLabel: UILabel!
    var contentLabel: UILabel!
    var dateIntervalLabel: UILabel!
    var remainingTimeLabel: UILabel!
    
    var blueToWhiteLocation : NSNumber?
    
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
        self.selectionStyle = .none
        
        let viewX = (UIScreen.main.bounds.width - contentView.bounds.width) / 2
        let viewY: CGFloat = 0
        let viewWidth = contentView.bounds.width
        let viewHeight:CGFloat = 100
        view = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight))
        contentView.addSubview(view)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
    
    func updateValues(assignment: Task, tableViewBackgroundColor: UIColor?, delegate: AssignmentsViewController) {
        self.assignment = assignment
        self.delegate = delegate
        
        if let tableViewBackgroundColor = tableViewBackgroundColor {
            self.backgroundColor = tableViewBackgroundColor
        }
        
        view.layer.sublayers?.remove(at: 0)
        
        //        if view.layer.sublayers != nil {
        //            view.layer.sublayers?.remove(at: 0)
        //        }
        //
        //        if assignment.isFinished {
        //            view.addGradientLayer(colors: [UIColor.spring.cgColor, UIColor.white.cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        //        } else {
        //            blueToWhiteLocation = getGradientLayerBlueToWhiteLocation()
        //            view.addGradientLayer(colors: [UIColor.aqua.withAlphaComponent(0.8).cgColor, UIColor.white.cgColor], locations: [0.0, blueToWhiteLocation!], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
        //        }
        
        // Creates a content label
        contentLabel = UILabel(frame: CGRect(x: 10, y: 8, width: 300, height: 60))
        view.addSubview(contentLabel)
        
        contentLabel.text = assignment.content
        contentLabel.numberOfLines = 3
        contentLabel.lineBreakMode = .byTruncatingTail
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Creates a date interval label
        dateIntervalLabel = UILabel(frame: CGRect(x: 10, y: 80, width: 200, height: 10))
        view.addSubview(dateIntervalLabel)
        
        dateIntervalLabel.text = "\(assignment.dateInterval.start.shortDateTimeStringWithoutWeekday) - \(assignment.dateInterval.end.shortDateTimeStringWithWeekday)"
        dateIntervalLabel.font = UIFont.systemFont(ofSize: 13)
        dateIntervalLabel.textColor = .gray
//        if assignment.remainingTime.day! == 0 {
//            dateIntervalLabel.textColor = .red
//        }
        
        // Creates a remaining time label
        remainingTimeLabel = UILabel(frame: CGRect(x: 210, y: 80, width: 100, height: 10))
        view.addSubview(remainingTimeLabel)
        
        remainingTimeLabel.text = assignment.timeAvailable.shortString
        remainingTimeLabel.textAlignment = .right
        remainingTimeLabel.font = UIFont.systemFont(ofSize: 13)
        remainingTimeLabel.textColor = .gray
//        if assignment.remainingTime.day! == 0 {
//            remainingTimeLabel.textColor = .red
//        }
        
        updateStatus()
    }
    
    func getGradientLayerBlueToWhiteLocation() -> NSNumber {
        let remainingHours = assignment!.timeAvailable.minutes
        let totalHours = assignment!.totalTime.minutes
        
        var blueToWhiteLocation: Double = Double(totalHours - remainingHours) / Double(totalHours)
        if blueToWhiteLocation < 0.1 {
            blueToWhiteLocation = 0.1
        }
        
        return NSNumber(value: blueToWhiteLocation)
    }
    
    func viewTapped() {
        //        view.layer.sublayers?.remove(at: 0)
        //
        //        if !assignment!.isFinished {
        //            contentLabel.textColor = .lightGray
        //            dateIntervalLabel.textColor = .lightGray
        //            remainingTimeLabel.textColor = .lightGray
        //            view.addGradientLayer(colors: [UIColor.spring.cgColor, UIColor.white.cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        //        } else {
        //            blueToWhiteLocation = getGradientLayerBlueToWhiteLocation()
        //
        //            contentLabel.textColor = .black
        //            dateIntervalLabel.textColor = .gray
        //            remainingTimeLabel.textColor = .gray
        //            view.addGradientLayer(colors: [UIColor.aqua.withAlphaComponent(0.8).cgColor, UIColor.white.cgColor], locations: [0.0, blueToWhiteLocation!], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
        //        }
        assignment?.isFinished.toggle()
        
        view.layer.sublayers?.remove(at: 0)
        updateStatus()
        
        delegate!.toggleFinishStatus(assignment: assignment!)
    }
    
    func updateStatus() {
        var contentLabelTextAttributes: [NSAttributedString.Key: Any] = [:]
        var dateIntervalLabelTextAttributes: [NSAttributedString.Key: Any] = [:]
        var remainingTimeLabelTextAttributes: [NSAttributedString.Key: Any] = [:]
        
        if assignment!.isFinished {
            let attributesOfFinishedAssignment: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.lightGray
            ]
            
            contentLabelTextAttributes = attributesOfFinishedAssignment
            dateIntervalLabelTextAttributes = attributesOfFinishedAssignment
            remainingTimeLabelTextAttributes = attributesOfFinishedAssignment
            
            view.addGradientLayer(colors: [UIColor.white.cgColor, UIColor.white.cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        } else {
            var timeColorOfUnfinishedAssigment: UIColor = .gray
            if assignment!.timeAvailable.day! <= 3 {
                timeColorOfUnfinishedAssigment = .red
            }
            
            contentLabelTextAttributes = [.foregroundColor: UIColor.black]
            dateIntervalLabelTextAttributes = [.foregroundColor: timeColorOfUnfinishedAssigment]
            remainingTimeLabelTextAttributes = [.foregroundColor: timeColorOfUnfinishedAssigment]
            
            blueToWhiteLocation = getGradientLayerBlueToWhiteLocation()
            view.addGradientLayer(colors: [UIColor.aqua.withAlphaComponent(0.6).cgColor, UIColor.white.cgColor], locations: [0.0, blueToWhiteLocation!], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
        }
        
        updateTextAttributes(label: contentLabel, attributes: contentLabelTextAttributes)
        updateTextAttributes(label: dateIntervalLabel, attributes: dateIntervalLabelTextAttributes)
        updateTextAttributes(label: remainingTimeLabel, attributes: remainingTimeLabelTextAttributes)
    }
    
    func updateTextAttributes(label: UILabel, attributes: [NSAttributedString.Key: Any]) {
        label.attributedText = NSAttributedString(string: label.text!, attributes: attributes)
    }
}



protocol AssignmentTableViewCellDelegate {
    func toggleFinishStatus(assignment: Task)
}
