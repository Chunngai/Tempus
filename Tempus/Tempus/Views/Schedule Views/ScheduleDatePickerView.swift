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
    
    // MARK: - Controllers
    
    var scheduleViewController: ScheduleViewController!
    
    // MARK: - Views
    
    var gradientLayer = CAGradientLayer()
    var datePicker: UIDatePicker!
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(datePickerFrame: CGRect, scheduleViewController: ScheduleViewController) {
        super.init(frame: UIScreen.main.bounds)
        
        // MARK: Controllers init
        
        self.scheduleViewController = scheduleViewController
        
        // MARK: Views init
        
        // The frame is the whole screen.
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        // Date picker.
        datePicker = UIDatePicker(frame: datePickerFrame)
        addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date(timeInterval: 24 * 3600, since: Date())
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.addGradientLayer(gradientLayer: gradientLayer,
                                    colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
                                    locations: [0.0, 1.0],
                                    startPoint: CGPoint(x: 0, y: 1),
                                    endPoint: CGPoint(x: 1, y: 0),
                                    frame: self.bounds)
        datePicker.layer.cornerRadius = 10
        datePicker.layer.masksToBounds = true
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

    @objc func datePickerValueChanged() {
        scheduleViewController.changeSchedule()
    }
}
