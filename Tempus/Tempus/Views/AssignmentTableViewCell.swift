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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateValues(assignment: Task) {
        self.assignment = assignment
        
        blueToWhiteLocation = getGradientLayerBlueToWhiteLocation()
        view.addGradientLayer(colors: [UIColor.aqua.withAlphaComponent(0.8).cgColor, UIColor.white.cgColor], locations: [0.0, blueToWhiteLocation!], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
//        // Creates a side bar label
//        sideBarLabel = UILabel(frame: CGRect(x: view.bounds.minX, y: view.bounds.minY, width: 20, height: view.bounds.height))
//        view.addSubview(sideBarLabel)
//
//        sideBarLabel.addGradientLayer(colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
//        setSideBarLabelBackgroundColor()
        
        // Creates a content label
        contentLabel = UILabel(frame: CGRect(x: 10, y: 8, width: 300, height: 60))
        view.addSubview(contentLabel)

        contentLabel.text = assignment.content
        contentLabel.numberOfLines = 3
        contentLabel.lineBreakMode = .byTruncatingTail
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Creates a date interval label
        dateIntervalLabel = UILabel(frame: CGRect(x: 10, y: 80, width: 160, height: 10))
        view.addSubview(dateIntervalLabel)

        dateIntervalLabel.text = "\(assignment.dateInterval.start.shortDateTimeString) - \(assignment.dateInterval.end.shortDateTimeString)"
        dateIntervalLabel.font = UIFont.systemFont(ofSize: 13)
        dateIntervalLabel.textColor = .gray
        if assignment.remainingTime.day! == 0 {
            dateIntervalLabel.textColor = .red
        }
        
        // Creates a remaining time label
        remainingTimeLabel = UILabel(frame: CGRect(x: 170, y: 80, width: 140, height: 10))
        view.addSubview(remainingTimeLabel)

        remainingTimeLabel.text = assignment.remainingTime.shortString
        remainingTimeLabel.textAlignment = .right
        remainingTimeLabel.font = UIFont.systemFont(ofSize: 13)
        remainingTimeLabel.textColor = .gray
        if assignment.remainingTime.day! == 0 {
            remainingTimeLabel.textColor = .red
        }
    }
    
    func getGradientLayerBlueToWhiteLocation() -> NSNumber {
        let remainingHours = assignment!.remainingTime.hours
        let totalHours = assignment!.totalTime.hours
        
        let blueToWhiteLocation: Double = Double(remainingHours) / Double(totalHours)
        
        return NSNumber(value: blueToWhiteLocation)
    }
    
    @objc func viewTapped() {
        view.layer.sublayers?.remove(at: 0)

        if !assignment!.isFinished {
            contentLabel.textColor = .lightGray
            dateIntervalLabel.textColor = .lightGray
            remainingTimeLabel.textColor = .lightGray
            view.addGradientLayer(colors: [UIColor.spring.cgColor, UIColor.white.cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        } else {
            contentLabel.textColor = .black
            dateIntervalLabel.textColor = .gray
            remainingTimeLabel.textColor = .gray
            view.addGradientLayer(colors: [UIColor.aqua.withAlphaComponent(0.8).cgColor, UIColor.white.cgColor], locations: [0.0, blueToWhiteLocation!], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
        }
        
        assignment?.isFinished.toggle()
        
        // TODO: change the assignment in the table view
        // TODO: shou a sign of completion
    }
    
//    func setSideBarLabelBackgroundColor() {
//        var colors: [CGColor]
//
//        switch assignment!.remainingTime.day {
//        case 0:
//            colors = [UIColor.maraschino.cgColor, UIColor.salmon.cgColor]
//        case 1, 2, 3:
//            colors = [UIColor.lemon.cgColor, UIColor.banana.cgColor]
//        default:
//            colors = [UIColor.aqua.cgColor, UIColor.sky.cgColor]
//        }
//
//        if assignment!.isFinished {
//            colors = [UIColor.spring.cgColor, UIColor.flora.cgColor]
//        }
//
//        sideBarLabel.addGradientLayer(colors: colors, locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
//    }
}
