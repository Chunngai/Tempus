//
//  ScheduleDatePicker.swift
//  Tempus
//
//  Created by Sola on 2020/3/27.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ScheduleDatePickerPopView: UIView {
    
    // MARK: - Controllers
    
    var scheduleViewController: ScheduleViewController!
    
    // MARK: - Views
    
    var gradientLayer = CAGradientLayer()
    
    var contentView: UIView!
    
    var todayButton = UIButton()
    var datePicker = UIDatePicker()
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(datePickerFrame: CGRect, scheduleViewController: ScheduleViewController, date: Date) {
        super.init(frame: UIScreen.main.bounds)
                
        self.scheduleViewController = scheduleViewController
                
        // The frame is the whole screen.
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        // Content view.
        contentView = UIView(frame: datePickerFrame)
        addSubview(contentView)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        contentView.addGradientLayer(gradientLayer: gradientLayer,
                                     colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
                                     locations: [0.0, 1.0],
                                     startPoint: CGPoint(x: 0, y: 1),
                                     endPoint: CGPoint(x: 1, y: 0),
                                     frame: contentView.bounds)
        
        // Today button.
        contentView.addSubview(todayButton)
        todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
        
        todayButton.setTitle("Today", for: .normal)
        todayButton.setTitleColor(UIColor.blue.withAlphaComponent(0.3), for: .normal)
            
        todayButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(3)
        }
        
        // Date picker.
        contentView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.date = date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date(timeInterval: 24 * 3600, since: Date())
                        
        datePicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(todayButton).inset(35)
        }
    }
    
    // MARK: - UIView funcs
    
    // Taps to make disappear.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (view) in
            self.removeFromSuperview()
        }
    }
    
    // Taps to make disappear.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (view) in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Customized funcs

    @objc func todayButtonTapped() {
        datePicker.date = Date().currentTimeZone()
        scheduleViewController.changeSchedule()
    }
    
    @objc func datePickerValueChanged() {
        scheduleViewController.changeSchedule()
    }
}
