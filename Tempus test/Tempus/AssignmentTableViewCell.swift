//
//  AssignmentTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/2/8.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    var delegate: AssignmentsTableViewController?
 
    var verticalStackView: UIStackView!
    var horizontalStackView: UIStackView!
    var courseContentLabel: UILabel!
    var dueDateLabel: UILabel!
    var statusButton: UIButton!
    
//    @IBOutlet var courseContentLabel: UILabel!
//    @IBOutlet var dueDateLabel: UILabel!
//    @IBOutlet var statusButton: UIButton!
    var status: Bool? {
        didSet {
            statusButton.setTitle(self.status! ? "🟢" : "🟡", for: .normal)
            courseContentLabel.textColor = self.status! ? .lightGray : .black
            dueDateLabel.textColor = self.status! ? .lightGray : .black
        }
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateView() {
//        self.backgroundColor = .black
        self.selectionStyle = .none
//        self.accessoryType = .disclosureIndicator
        
        
        
//        courseContentLabel.textColor = .systemTeal
        courseContentLabel = UILabel()
        courseContentLabel.font = UIFont.systemFont(ofSize: 18)
        courseContentLabel.lineBreakMode = .byWordWrapping
        courseContentLabel.numberOfLines = 0
        
        

//        dueDateLabel.textColor = .systemTeal
        dueDateLabel = UILabel()
        dueDateLabel.textAlignment = .left
        dueDateLabel.font = UIFont.systemFont(ofSize: 16)
        
        statusButton = UIButton()
        statusButton.contentHorizontalAlignment = .right
        statusButton.addTarget(self, action: #selector(statusButtonTapped(_:)), for: .touchUpInside)
        
        horizontalStackView = UIStackView(arrangedSubviews: [dueDateLabel, statusButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 0
        
        verticalStackView = UIStackView(arrangedSubviews: [courseContentLabel, horizontalStackView])
        verticalStackView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 3
        contentView.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let top:NSLayoutConstraint = NSLayoutConstraint(item: verticalStackView!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 10)
        verticalStackView.superview!.addConstraint(top)
        
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: verticalStackView!, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -10)
        verticalStackView.superview!.addConstraint(bottom)
        
        let leading: NSLayoutConstraint = NSLayoutConstraint(item: verticalStackView!, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 20)
        verticalStackView.superview!.addConstraint(leading)
        
        let trailing: NSLayoutConstraint = NSLayoutConstraint(item: verticalStackView!, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -20)
        verticalStackView.superview!.addConstraint(trailing)
    }
    
    func updateValue(assignment: Assignment) {
        courseContentLabel.text = assignment.content
        dueDateLabel.text = assignment.dueDateString
        statusButton.setTitle(assignment.status ? "🟢" : "🟡", for: .normal)
        status = assignment.status ? true : false
    }
    
    @objc func statusButtonTapped(_ sender: UIButton) {
        status?.toggle()
        delegate?.checkMarkTapped(sender: self)
    }
}


protocol AssignmentTableViewCellDelegate {
    func checkMarkTapped(sender: AssignmentTableViewCell)
}
