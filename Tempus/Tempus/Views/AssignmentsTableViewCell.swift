//
//  AssignmentTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/2/11.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentsTableViewCell: UITableViewCell {
    
    var assignment: Task?
    var delegate: AssignmentsViewController?
    
    var view: UIView!
    var sideBarLabel: UILabel!
    var contentLabel: UILabel!
    var dateIntervalLabel: UILabel!
    var availableTimeLabel: UILabel!
    
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
        
        updateinitialViews()
    }
    
    func updateinitialViews() {
        self.selectionStyle = .none
        
        // Creates a view.
        // TODO: f
        let viewX = (UIScreen.main.bounds.width - contentView.bounds.width) / 2
        let viewY: CGFloat = 0
        let viewWidth = contentView.bounds.width
        let viewHeight:CGFloat = 100
        
        view = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight))
        contentView.addSubview(view)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        // Creates a content label.
        // TODO: f
        contentLabel = UILabel(frame: CGRect(x: 10, y: 8, width: 300, height: 60))
        view.addSubview(contentLabel)
        
        contentLabel.numberOfLines = 3
        contentLabel.lineBreakMode = .byTruncatingTail
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Creates a date interval label.
        // TODO: f
        dateIntervalLabel = UILabel(frame: CGRect(x: 10, y: 80, width: 200, height: 10))
        view.addSubview(dateIntervalLabel)
        
        dateIntervalLabel.font = UIFont.systemFont(ofSize: 13)
        
        // Creates a remaining time label.
        availableTimeLabel = UILabel(frame: CGRect(x: 210, y: 80, width: 100, height: 10))
        view.addSubview(availableTimeLabel)
        
        availableTimeLabel.textAlignment = .right
        availableTimeLabel.font = UIFont.systemFont(ofSize: 13)
        
        // Creates a gradient layer.
        gradientLayer = CAGradientLayer()
    }
    
    func updateValues(assignment: Task, tableViewBackgroundColor: UIColor?, delegate: AssignmentsViewController) {
        self.assignment = assignment
        self.delegate = delegate
        self.backgroundColor = tableViewBackgroundColor
        
        // Updates texts.
        contentLabel.text = assignment.content
        dateIntervalLabel.text = "\(assignment.dateInterval.start.shortDateTimeStringWithoutWeekday) - \(assignment.dateInterval.end.shortDateTimeStringWithWeekday)"
        
        // Updates attributes related to whether the assignment is finished.
        updateViewsRelatedToAssignmentStatus()
    }
    
    func getGradientLayerBlueToWhiteLocation() -> NSNumber {
        let availableMinutes = assignment!.availableTime.minutes
        let totalMinutes = assignment!.totalTime.minutes
        
        var blueToWhiteLocation: Double = Double(totalMinutes - availableMinutes) / Double(totalMinutes)
        
        // Guarantees that the view color is more or less colored blue til the assignment is finished.
        if blueToWhiteLocation < 0.1 {
            blueToWhiteLocation = 0.1
        }
        
        return NSNumber(value: blueToWhiteLocation)
    }
    
    func viewTapped() {
        assignment?.isFinished.toggle()
        
        updateViewsRelatedToAssignmentStatus()
        
        delegate!.toggleFinishStatus(assignment: assignment!)
    }
    
    func updateViewsRelatedToAssignmentStatus() {
        var availableTimeLabelText = ""
        
        var contentLabelTextAttributes: [NSAttributedString.Key: Any] = [:]
        var dateIntervalLabelTextAttributes: [NSAttributedString.Key: Any] = [:]
        var availableTimeLabelTextAttributes: [NSAttributedString.Key: Any] = [:]
        
        var colors: [CGColor] = []
        var locations: [NSNumber] = []
        
        if assignment!.isFinished {
            let attributesOfFinishedAssignment: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.lightGray
            ]
            
            contentLabelTextAttributes = attributesOfFinishedAssignment
            dateIntervalLabelTextAttributes = attributesOfFinishedAssignment
            availableTimeLabelTextAttributes = attributesOfFinishedAssignment
            
            availableTimeLabelText = assignment!.availableTime.shortString
            
            colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            locations = [0.0, 1.0]
        } else {
            var timeColorOfUnfinishedAssigment: UIColor = .gray
            if assignment!.availableTime.day! <= 3 {
                timeColorOfUnfinishedAssigment = .red
            }
            
            contentLabelTextAttributes = [.foregroundColor: UIColor.black]
            dateIntervalLabelTextAttributes = [.foregroundColor: timeColorOfUnfinishedAssigment]
            availableTimeLabelTextAttributes = [.foregroundColor: timeColorOfUnfinishedAssigment]
            
            var emoji = ""
            if assignment?.availableTime.month == 0 {
                if assignment!.availableTime.day! >= 1 && assignment!.availableTime.day! <= 3 {
                    emoji = "⚠️"
                } else if assignment!.availableTime.day! <= 1 {
                    emoji = "‼️"
                }
                
                if assignment!.isOverDue {
                    emoji = "💢"
                }
            }
            availableTimeLabelText = emoji + assignment!.availableTime.shortString
            
            colors = [UIColor.aqua.withAlphaComponent(0.5).cgColor, UIColor.white.cgColor]
            let blueToWhiteLocation = getGradientLayerBlueToWhiteLocation()
            locations = [0.0, blueToWhiteLocation]
        }
        
        contentLabel.attributedText = NSAttributedString(string: contentLabel.text!, attributes: contentLabelTextAttributes)
        dateIntervalLabel.attributedText = NSAttributedString(string: dateIntervalLabel.text!, attributes: dateIntervalLabelTextAttributes)
        availableTimeLabel.attributedText = NSAttributedString(string: availableTimeLabelText, attributes: availableTimeLabelTextAttributes)
        
        view.addGradientLayer(gradientLayer: gradientLayer, colors: colors, locations: locations, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
    }
}

protocol AssignmentTableViewCellDelegate {
    func toggleFinishStatus(assignment: Task)
}
