//
//  ScheduleDatePicker.swift
//  Tempus
//
//  Created by Sola on 2020/3/27.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ScheduleDatePickerView: UIView {
    // Controllers.
    var scheduleViewController: ScheduleViewController!
    
    // Views.
    var gradientLayer = CAGradientLayer()
    var datePicker = UIDatePicker()

    // Initializers.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateViews()
    }
    
    // Customized funcs.
    func updateViews() {
        // Gradient layer.
        self.addGradientLayer(gradientLayer: gradientLayer,
            colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
            locations: [0.0, 1.0],
            startPoint: CGPoint(x: 0, y: 1),
            endPoint: CGPoint(x: 1, y: 0),
            frame: self.bounds)
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        // Date picker.
        self.addSubview(datePicker)

        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date(timeInterval: 24 * 3600, since: Date())
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        datePicker.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.4 * 0.1)
        }
    }
    
    func updateValues(scheduleViewController: ScheduleViewController) {        
        self.scheduleViewController = scheduleViewController
    }
    
    @objc func datePickerValueChanged() {
        scheduleViewController.changeSchedule()
    }
}
