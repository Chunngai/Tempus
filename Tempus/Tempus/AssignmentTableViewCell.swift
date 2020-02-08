//
//  AssignmentTableViewCell.swift
//  Tempus
//
//  Created by Sola on 2020/2/8.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet var courseContentLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(assignment: Assignment) {
        self.backgroundColor = .black
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        courseContentLabel.textColor = .systemTeal
        courseContentLabel.font = UIFont.systemFont(ofSize: 20)
        courseContentLabel.text = assignment.content
        courseContentLabel.lineBreakMode = .byWordWrapping
        courseContentLabel.numberOfLines = 0

        dueDateLabel.textColor = .systemTeal
        dueDateLabel.text = assignment.dueDateString
        dueDateLabel.textAlignment = .right
    }
}
