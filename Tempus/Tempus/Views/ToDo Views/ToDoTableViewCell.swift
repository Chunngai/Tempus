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
    
    var task: Task?
    var toDoViewController: ToDoViewController!
        
    // Views.
    var view = UIView()
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
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(5)
        }
        
        // Content label.
        view.addSubview(contentLabel)
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentLabel.textColor = .white
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().inset(15)
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
        let longPressedGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed))
        view.addGestureRecognizer(longPressedGestureRecognizer)
    }
    
    func updateValues(task: Task, toDoViewController: ToDoViewController) {
        self.task = task
        self.toDoViewController = toDoViewController
        
        // Updates the text content.
        contentLabel.text = task.content
    }
    
    @objc func viewLongPressed() {
        if let toDoEditNavigationViewController = toDoViewController.presentedViewController,
            toDoEditNavigationViewController is ToDoEditNavigationViewController {
            return
        }
        
        toDoViewController.presentEditingView(task: task!)
    }
}